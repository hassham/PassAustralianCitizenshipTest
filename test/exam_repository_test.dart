import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/exams/data/exam_repository.dart';
import 'package:pass_citizenship_test/features/exams/application/exam_controller.dart';
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
    expect(started.questions, hasLength(20));
    expect(
      started.questions
          .where((question) => question.isAustralianValuesQuestion),
      hasLength(5),
    );

    await repository.saveAnswer(
      attemptId: started.attemptId,
      questionOrder: 0,
      selectedIndex: 2,
      selectedOptionId: started.questions.first.options[2].id,
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

  test('fails a nineteen out of twenty exam when one values answer is wrong', () async {
    final started = await repository.startExam();
    final answers = {
      for (var index = 0; index < started.questions.length; index++)
        index: started.questions[index].correctIndex,
    };
    final valuesIndex = started.questions.indexWhere(
      (question) => question.isAustralianValuesQuestion,
    );
    final valuesQuestion = started.questions[valuesIndex];
    answers[valuesIndex] =
        (valuesQuestion.correctIndex + 1) % valuesQuestion.options.length;

    final result = await repository.submit(
      attemptId: started.attemptId,
      questions: started.questions,
      answers: answers,
      passPercentage: started.config.passPercentage,
    );

    expect(result.score, 95);
    expect(result.overallRequirementMet, isTrue);
    expect(result.australianValuesCorrect, 4);
    expect(result.australianValuesRequirementMet, isFalse);
    expect(result.passed, isFalse);
  });

  test('scores answered, incorrect, and unanswered questions', () async {
    final started = await repository.startExam();
    final first = started.questions[0];
    final second = started.questions[1];
    final wrongIndex = (second.correctIndex + 1) % second.options.length;
    final answers = {0: first.correctIndex, 1: wrongIndex};
    await repository.saveAnswer(
      attemptId: started.attemptId,
      questionOrder: 0,
      selectedIndex: first.correctIndex,
      selectedOptionId: first.options[first.correctIndex].id,
    );
    await repository.saveAnswer(
      attemptId: started.attemptId,
      questionOrder: 1,
      selectedIndex: wrongIndex,
      selectedOptionId: second.options[wrongIndex].id,
    );

    final result = await repository.submit(
      attemptId: started.attemptId,
      questions: started.questions,
      answers: answers,
      passPercentage: started.config.passPercentage,
    );

    expect(result.correct, 1);
    expect(result.incorrect, 1);
    expect(result.unanswered, 18);
    expect(result.score, closeTo(5, 0.001));
    expect(result.passed, isFalse);
    expect(await repository.restoreExam(), isNull);

    final history = await repository.history();
    expect(history, hasLength(1));
    expect(history.single.correctAnswers, 1);
    final detail = await repository.historyDetail(started.attemptId);
    expect(detail.answers, hasLength(20));
    expect(detail.answers.first.selectedIndex, first.correctIndex);
    expect(detail.answers.first.question?.id, first.id);
  });

  test('restores a timed exam using elapsed real time', () async {
    final start = DateTime.utc(2026, 7, 24, 10);
    final started = await repository.startExam(timed: true, now: start);

    final restored = await repository.restoreExam(
      now: start.add(const Duration(minutes: 5)),
    );

    expect(started.isTimed, isTrue);
    expect(restored?.remainingSeconds, 40 * 60);
    expect(restored?.timerLocked, isFalse);
  });

  test(
    'auto-submits an expired timed exam during controller restore',
    () async {
      final start = DateTime.utc(2026, 7, 24, 10);
      await repository.startExam(timed: true, now: start);
      final controller = ExamController(
        repository,
        clock: () => start.add(const Duration(minutes: 46)),
      );
      addTearDown(controller.dispose);

      final restored = await controller.restore();

      expect(restored, isTrue);
      expect(controller.state.result?.timedOut, isTrue);
      expect(controller.state.result?.unanswered, 20);
    },
  );
}
