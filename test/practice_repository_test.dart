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
    expect(questions, hasLength(120));
    expect(questions.first.options, hasLength(4));
    expect(
      questions.first.options.every((option) => option.explanation.isNotEmpty),
      isTrue,
    );
    expect(questions.first.references, isNotEmpty);
  });

  test('records progress and restores an unfinished session', () async {
    final questions = await repository.questions('values');
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
}
