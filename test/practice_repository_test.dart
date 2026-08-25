import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/practice/data/practice_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late PracticeRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = PracticeRepository(database);
  });

  tearDown(() => database.close());

  test('imports bundled categories and questions once', () async {
    await repository.initialise();
    await repository.initialise();

    final categories = await repository.categories();
    final questions = await repository.questions();

    expect(categories, hasLength(4));
    expect(questions, hasLength(421));
    expect(questions.first.options, hasLength(4));
    expect(
      questions.first.options.every((option) => option.explanation.isNotEmpty),
      isTrue,
    );
    expect(questions.first.references, isNotEmpty);
  });

  test(
    'bundled correct answers are balanced across option positions',
    () async {
      final questions = await repository.questions();
      final counts = List<int>.filled(4, 0);
      for (final question in questions) {
        counts[question.correctIndex]++;
      }

      expect(counts.reduce((a, b) => a > b ? a : b), lessThanOrEqualTo(106));
      expect(counts.reduce((a, b) => a < b ? a : b), greaterThanOrEqualTo(105));
    },
  );

  test('records progress and restores an unfinished session', () async {
    final original = await repository.questions('values');
    final first = original.first;
    final questions = [
      first.withOptions(first.options.reversed.toList()),
      ...original.skip(1),
    ];
    final sessionId = await repository.createSession('values', questions);

    await repository.recordAnswer(
      sessionId: sessionId,
      question: questions.first,
      selectedIndex: questions.first.correctIndex,
      nextIndex: 1,
      correctCount: 1,
      complete: false,
    );

    final restored = await repository.restoreSession();
    final progress = await repository.progress();
    expect(restored?.currentIndex, 1);
    expect(restored?.correctCount, 1);
    expect(
      restored?.questions.first.options.map((option) => option.id),
      questions.first.options.map((option) => option.id),
    );
    expect(progress.attempted, 1);
    expect(progress.accuracy, 100);
  });

  test('stars and unstars a question persistently', () async {
    final questions = await repository.questions();
    final questionId = questions.first.id;

    expect(await repository.toggleStarred(questionId), isTrue);
    expect(await repository.starredIds(), contains(questionId));
    expect(await repository.starredQuestions(), hasLength(1));

    expect(await repository.toggleStarred(questionId), isFalse);
    expect(await repository.starredIds(), isNot(contains(questionId)));
    expect(await repository.starredQuestions(), isEmpty);
  });

  test('filters multiple categories and limits the session length', () async {
    final questions = await repository.questionsFor(
      categoryIds: {'values', 'people'},
      limit: 5,
    );

    expect(questions, hasLength(5));
    expect(
      questions.every(
        (question) => {'values', 'people'}.contains(question.categoryId),
      ),
      isTrue,
    );
  });

  test('filters practice questions by difficulty', () async {
    final questions = await repository.questionsFor(difficulties: {'easy'});

    expect(questions, isNotEmpty);
    expect(
      questions.every((question) => question.difficulty == 'easy'),
      isTrue,
    );
  });

  test('builds Home dashboard counts and active-session state', () async {
    final initial = await repository.homeDashboard();
    expect(initial.totalQuestions, 421);
    expect(initial.starredQuestions, 0);
    expect(initial.hasActivePractice, isFalse);
    expect(initial.hasActiveExam, isFalse);

    final questions = await repository.questionsFor(limit: 5);
    await repository.createSession(null, questions);
    await repository.toggleStarred(questions.first.id);

    final updated = await repository.homeDashboard();
    expect(updated.hasActivePractice, isTrue);
    expect(updated.starredQuestions, 1);
  });
}
