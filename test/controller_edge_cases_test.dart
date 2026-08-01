import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/exams/application/exam_controller.dart';
import 'package:pass_citizenship_test/features/exams/data/exam_repository.dart';
import 'package:pass_citizenship_test/features/practice/application/practice_controller.dart';
import 'package:pass_citizenship_test/features/practice/data/practice_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late PracticeRepository practiceRepository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    practiceRepository = PracticeRepository(database);
  });

  tearDown(() => database.close());

  test(
    'practice ignores duplicate answers and navigation before answering',
    () async {
      final controller = PracticeController(practiceRepository);
      addTearDown(controller.dispose);
      await controller.startSelection(questionCount: 2);

      await controller.next();
      expect(controller.state.index, 0);

      final correctIndex = controller.state.current!.correctIndex;
      controller.selectAnswer(correctIndex);
      controller.selectAnswer((correctIndex + 1) % 4);

      expect(controller.state.selectedIndex, correctIndex);
      expect(controller.state.correctCount, 1);
    },
  );

  test(
    'practice starred session remains idle when there are no stars',
    () async {
      final controller = PracticeController(practiceRepository);
      addTearDown(controller.dispose);

      expect(await controller.startStarred(), isFalse);
      expect(controller.state.questions, isEmpty);
      expect(controller.state.loading, isFalse);
    },
  );

  test(
    'exam ignores invalid navigation and safely restores no active exam',
    () async {
      final controller = ExamController(
        ExamRepository(database, practiceRepository),
      );
      addTearDown(controller.dispose);

      expect(await controller.restore(), isFalse);
      await controller.goTo(-1);
      await controller.goTo(1);
      await controller.selectAnswer(0);

      expect(controller.state.currentIndex, 0);
      expect(controller.state.answers, isEmpty);
      expect(controller.state.error, isNull);
    },
  );

  test('locked exam refuses answer changes', () async {
    final startedAt = DateTime.utc(2026, 8, 1, 10);
    final repository = ExamRepository(database, practiceRepository);
    await repository.startExam(timed: true, now: startedAt);
    final controller = ExamController(
      repository,
      clock: () => startedAt.subtract(const Duration(seconds: 1)),
    );
    addTearDown(controller.dispose);
    await controller.restore();

    await controller.selectAnswer(0);

    expect(controller.state.timerLocked, isTrue);
    expect(controller.state.answers, isEmpty);
  });
}
