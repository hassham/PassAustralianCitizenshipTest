import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:pass_citizenship_test/core/errors/app_failure.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/exams/application/exam_controller.dart';
import 'package:pass_citizenship_test/features/exams/data/exam_repository.dart';
import 'package:pass_citizenship_test/features/practice/application/practice_controller.dart';
import 'package:pass_citizenship_test/features/practice/data/practice_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // This suite intentionally reopens a file-backed database sequentially
  // (always closing the previous instance first) to simulate corruption and
  // recovery; that's expected here, not the concurrent-access bug this warns
  // about.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase database;
  late PracticeRepository practiceRepository;
  late ExamRepository examRepository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    practiceRepository = PracticeRepository(database);
    examRepository = ExamRepository(database, practiceRepository);
  });

  tearDown(() => database.close());

  testWidgets('completes and persists a full practice session', (tester) async {
    final controller = PracticeController(practiceRepository);
    addTearDown(controller.dispose);

    await controller.startSelection(questionCount: 5);
    expect(controller.state.questions, hasLength(5));

    while (!controller.state.complete) {
      controller.selectAnswer(controller.state.current!.correctIndex);
      await controller.next();
    }

    expect(controller.state.correctCount, 5);
    expect((await practiceRepository.progress()).attempted, 5);
    expect(await practiceRepository.restoreSession(), isNull);
  });

  testWidgets('completes untimed and timed mock exams', (tester) async {
    final untimed = await examRepository.startExam(timed: false);
    final untimedAnswers = {
      for (var index = 0; index < untimed.questions.length; index++)
        index: untimed.questions[index].correctIndex,
    };
    final untimedResult = await examRepository.submit(
      attemptId: untimed.attemptId,
      questions: untimed.questions,
      answers: untimedAnswers,
      passPercentage: untimed.config.passPercentage,
      requiredAustralianValuesQuestions:
          untimed.config.australianValuesQuestionCount,
    );

    final startedAt = DateTime.utc(2026, 8, 1, 10);
    final timed = await examRepository.startExam(timed: true, now: startedAt);
    final timedAnswers = {
      for (var index = 0; index < timed.questions.length; index++)
        index: timed.questions[index].correctIndex,
    };
    final timedResult = await examRepository.submit(
      attemptId: timed.attemptId,
      questions: timed.questions,
      answers: timedAnswers,
      passPercentage: timed.config.passPercentage,
      requiredAustralianValuesQuestions:
          timed.config.australianValuesQuestionCount,
      remainingSeconds: timed.remainingSeconds,
    );

    expect(untimedResult.passed, isTrue);
    expect(timedResult.passed, isTrue);
    expect((await examRepository.history()), hasLength(2));
  });

  testWidgets('restores practice and exam state after controller recreation', (
    tester,
  ) async {
    final practiceQuestions = await practiceRepository.questionsFor(limit: 3);
    final sessionId = await practiceRepository.createSession(
      null,
      practiceQuestions,
    );
    await practiceRepository.recordAnswer(
      sessionId: sessionId,
      question: practiceQuestions.first,
      selectedIndex: practiceQuestions.first.correctIndex,
      nextIndex: 1,
      correctCount: 1,
      complete: false,
    );

    final restoredPractice = PracticeController(practiceRepository);
    addTearDown(restoredPractice.dispose);
    expect(await restoredPractice.restore(), isTrue);
    expect(restoredPractice.state.index, 1);
    expect(restoredPractice.state.correctCount, 1);

    final exam = await examRepository.startExam(timed: false);
    final selectedIndex = exam.questions.first.correctIndex;
    await examRepository.saveAnswer(
      attemptId: exam.attemptId,
      questionOrder: 0,
      selectedIndex: selectedIndex,
      selectedOptionId: exam.questions.first.options[selectedIndex].id,
    );
    await examRepository.savePosition(exam.attemptId, 4);

    final restoredExam = ExamController(examRepository);
    addTearDown(restoredExam.dispose);
    expect(await restoredExam.restore(), isTrue);
    expect(restoredExam.state.currentIndex, 4);
    expect(restoredExam.state.answers[0], selectedIndex);
  });

  testWidgets('expires and auto-submits a timed exam after backgrounding', (
    tester,
  ) async {
    var now = DateTime.utc(2026, 8, 1, 10);
    final controller = ExamController(examRepository, clock: () => now);
    addTearDown(controller.dispose);

    await controller.start();
    await controller.handleBackgrounded();
    now = now.add(const Duration(minutes: 46));
    await controller.handleResumed();

    expect(controller.state.result?.timedOut, isTrue);
    expect(controller.state.result?.unanswered, 20);
  });

  testWidgets('locks a timed exam when the device clock moves backwards', (
    tester,
  ) async {
    final startedAt = DateTime.utc(2026, 8, 1, 10);
    await examRepository.startExam(timed: true, now: startedAt);
    final controller = ExamController(
      examRepository,
      clock: () => startedAt.subtract(const Duration(minutes: 1)),
    );
    addTearDown(controller.dispose);

    expect(await controller.restore(), isTrue);
    expect(controller.state.timerLocked, isTrue);
  });

  testWidgets('recovers safely when active content has been removed', (
    tester,
  ) async {
    final practiceQuestions = await practiceRepository.questionsFor(limit: 1);
    await practiceRepository.createSession(null, practiceQuestions);
    await _markRemoved(database, practiceQuestions.single.id);

    final practiceController = PracticeController(practiceRepository);
    addTearDown(practiceController.dispose);
    expect(await practiceController.restore(), isFalse);
    expect(practiceController.state.current, isNull);

    final exam = await examRepository.startExam(timed: false);
    await _markRemoved(database, exam.questions.first.id);

    await expectLater(
      examRepository.restoreExam(),
      throwsA(isA<ContentFailure>()),
    );
    expect(await database.activeExamAttempt(), isNull);
  });

  testWidgets(
    'recovers safely when the local database file is corrupted',
    (tester) async {
      final tempDir = await Directory.systemTemp.createTemp(
        'citizenship_corrupt_db_test',
      );
      addTearDown(() async {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      });
      final dbFile = File(p.join(tempDir.path, 'corrupt_test.sqlite'));

      // Seed a real, file-backed database with the imported bundled content.
      var fileDatabase = AppDatabase.forTesting(NativeDatabase(dbFile));
      await PracticeRepository(fileDatabase).initialise();
      expect(
        (await PracticeRepository(fileDatabase).questions()),
        isNotEmpty,
      );
      await fileDatabase.close();

      // Simulate real-world storage corruption by overwriting the file's bytes.
      final originalLength = await dbFile.length();
      await dbFile.writeAsBytes(List<int>.filled(originalLength, 0xFF));

      // Opening the corrupted file must surface a recoverable StorageFailure,
      // not crash the app or silently return empty content.
      fileDatabase = AppDatabase.forTesting(NativeDatabase(dbFile));
      await expectLater(
        PracticeRepository(fileDatabase).initialise(),
        throwsA(
          isA<StorageFailure>().having(
            (failure) => failure.canRetry,
            'canRetry',
            isTrue,
          ),
        ),
      );
      await fileDatabase.close();

      // Recovery mirrors PracticeRepository.resetLocalDataForRecovery(): the
      // corrupted file is deleted and the bundled content is re-imported into
      // a fresh database at the same location.
      if (await dbFile.exists()) await dbFile.delete();
      fileDatabase = AppDatabase.forTesting(NativeDatabase(dbFile));
      final recoveredRepository = PracticeRepository(fileDatabase);
      await recoveredRepository.initialise();
      expect(await recoveredRepository.questions(), isNotEmpty);
      await fileDatabase.close();
    },
  );
}

Future<void> _markRemoved(
  AppDatabase database,
  String questionId,
) => database.customStatement(
  'INSERT OR REPLACE INTO removed_questions '
  '(question_id, removed_at, reason, replacement_question_id, user_message) '
  'VALUES (?, ?, ?, ?, ?)',
  [
    questionId,
    DateTime.utc(2026, 8, 1).toIso8601String(),
    'content_update',
    null,
    'This question is no longer available.',
  ],
);
