import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/exams/data/exam_repository.dart';
import 'package:pass_citizenship_test/features/practice/data/practice_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late ExamRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ExamRepository(database, PracticeRepository(database));
  });

  tearDown(() => database.close());

  test('loads configuration and restores an unfinished exam', () async {
    final started = await repository.startExam();
    expect(started.config.questionCount, 20);
    expect(started.config.passPercentage, 75);
    expect(started.questions, hasLength(12));

    await repository.saveAnswer(
      attemptId: started.attemptId,
      questionOrder: 0,
      selectedIndex: 2,
    );
    await repository.savePosition(started.attemptId, 3);

    final restored = await repository.restoreExam();
    expect(restored?.currentIndex, 3);
    expect(restored?.answers[0], 2);
    expect(
      restored?.questions.map((question) => question.id),
      started.questions.map((question) => question.id),
    );
  });

  test('scores answered, incorrect, and unanswered questions', () async {
    final started = await repository.startExam();
    final first = started.questions[0];
    final second = started.questions[1];
    final wrongIndex = (second.correctIndex + 1) % second.options.length;
    final answers = {0: first.correctIndex, 1: wrongIndex};

    final result = await repository.submit(
      attemptId: started.attemptId,
      questions: started.questions,
      answers: answers,
      passPercentage: started.config.passPercentage,
    );

    expect(result.correct, 1);
    expect(result.incorrect, 1);
    expect(result.unanswered, 10);
    expect(result.score, closeTo(100 / 12, 0.001));
    expect(result.passed, isFalse);
    expect(await repository.restoreExam(), isNull);
  });
}
