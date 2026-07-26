import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/practice/data/practice_repository.dart';
import 'package:pass_citizenship_test/features/progress/data/readiness_insights_repository.dart';
import 'package:pass_citizenship_test/features/progress/data/progress_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'calculates readiness and ranks a statistically weak category',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final practice = PracticeRepository(database);
      final questions = await practice.questions();
      final strongQuestion = questions.firstWhere(
        (question) => question.difficulty != 'easy',
      );
      final weakQuestion = questions.firstWhere(
        (question) =>
            question.categoryId != strongQuestion.categoryId &&
            question.difficulty != 'easy',
      );
      final attemptedAt = DateTime.utc(2026, 7, 24);
      for (var index = 0; index < 5; index++) {
        await database
            .into(database.questionAttempts)
            .insert(
              QuestionAttemptsCompanion.insert(
                questionId: strongQuestion.id,
                selectedIndex: strongQuestion.correctIndex,
                isCorrect: true,
                attemptedAt: attemptedAt,
              ),
            );
        await database
            .into(database.questionAttempts)
            .insert(
              QuestionAttemptsCompanion.insert(
                questionId: weakQuestion.id,
                selectedIndex: (weakQuestion.correctIndex + 1) % 4,
                isCorrect: false,
                attemptedAt: attemptedAt,
              ),
            );
      }
      final progress = ProgressRepository(database, practice);
      final repository = ReadinessInsightsRepository(
        database,
        practice,
        progress,
      );

      final analytics = await repository.analytics(now: attemptedAt);

      expect(analytics.readiness.score, isNotNull);
      expect(analytics.weakAreas, hasLength(1));
      expect(analytics.weakAreas.single.categoryId, weakQuestion.categoryId);
      expect(
        analytics.weakAreas.single.frequentlyMissedQuestions,
        contains(weakQuestion.text),
      );
      expect(analytics.recommendations, isNotEmpty);
    },
  );
}
