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

    expect(categories, hasLength(3));
    expect(questions, hasLength(12));
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
}
