import 'package:drift/drift.dart';

import '../../../core/services/performance_monitor.dart';
import '../../../data/database/app_database.dart';
import '../../practice/data/practice_repository.dart';
import '../domain/premium_analytics_models.dart';
import '../domain/readiness_calculator.dart';
import '../domain/recommendation_engine.dart';
import 'progress_repository.dart';

class PremiumAnalyticsRepository {
  const PremiumAnalyticsRepository(
    this.database,
    this.practiceRepository,
    this.progressRepository,
  );

  final AppDatabase database;
  final PracticeRepository practiceRepository;
  final ProgressRepository progressRepository;

  Future<PremiumAnalyticsModel> analytics({DateTime? now}) =>
      PerformanceMonitor.measure(
        'premium_analytics',
        () => _calculate(now ?? DateTime.now()),
        warningThreshold: const Duration(milliseconds: 150),
      );

  Future<PremiumAnalyticsModel> _calculate(DateTime now) async {
    await practiceRepository.initialise();
    final progress = await progressRepository.analytics();
    final attempts = await database.select(database.questionAttempts).get();
    final questions = await database.select(database.studyQuestions).get();
    final metadata = await database
        .customSelect('SELECT question_id, difficulty FROM question_metadata')
        .get();
    final difficultyByQuestion = {
      for (final row in metadata)
        row.read<String>('question_id'): row.read<String>('difficulty'),
    };
    final exams =
        await (database.select(database.examAttempts)
              ..where((row) => row.submittedAt.isNotNull())
              ..orderBy([(row) => OrderingTerm.asc(row.submittedAt)]))
            .get();
    final scores = exams.map((exam) => exam.score ?? 0).toList();
    final difficulty = <String, DifficultyPerformance>{};
    for (final name in ['easy', 'medium', 'hard']) {
      final matching = attempts
          .where(
            (attempt) =>
                (difficultyByQuestion[attempt.questionId] ?? 'medium') == name,
          )
          .toList();
      difficulty[name] = DifficultyPerformance(
        matching.length,
        matching.where((attempt) => attempt.isCorrect).length,
      );
    }
    final lastExam = exams
        .map((exam) => exam.submittedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(
          null,
          (latest, date) =>
              latest == null || date.isAfter(latest) ? date : latest,
        );
    final lastActivity =
        progress.lastActivityAt == null ||
            (lastExam?.isAfter(progress.lastActivityAt!) ?? false)
        ? lastExam
        : progress.lastActivityAt;
    final readiness = ReadinessCalculator.calculate(
      ReadinessInput(
        practiceAttempts: progress.attempted,
        practiceCorrect: progress.correct,
        examScores: scores,
        activeCategories: progress.categories
            .where((category) => category.attempted > 0)
            .length,
        masteredCategories: progress.categories
            .where((category) => category.accuracy >= 80)
            .length,
        totalCategories: progress.categories.length,
        easy: difficulty['easy']!,
        medium: difficulty['medium']!,
        hard: difficulty['hard']!,
        lastActivityAt: lastActivity,
        now: now,
      ),
    );
    final questionCategory = {
      for (final question in questions) question.id: question.categoryId,
    };
    final questionText = {
      for (final question in questions) question.id: question.questionText,
    };
    final threshold = progress.accuracy - 15;
    final weakAreas = <WeakAreaModel>[];
    for (final category in progress.categories) {
      if (category.attempted < 5 || category.accuracy >= threshold) continue;
      final missedCounts = <String, int>{};
      for (final attempt in attempts.where(
        (attempt) =>
            questionCategory[attempt.questionId] == category.categoryId &&
            !attempt.isCorrect &&
            {
              'medium',
              'hard',
            }.contains(difficultyByQuestion[attempt.questionId] ?? 'medium'),
      )) {
        missedCounts.update(
          attempt.questionId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
      final missed =
          missedCounts.entries.where((entry) => entry.value >= 2).toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      weakAreas.add(
        WeakAreaModel(
          categoryId: category.categoryId,
          categoryName: category.categoryName,
          accuracy: category.accuracy,
          targetAccuracy: threshold.round(),
          severityGap: (threshold - category.accuracy).toDouble(),
          frequentlyMissedQuestions: missed
              .take(3)
              .map((entry) => questionText[entry.key] ?? entry.key)
              .toList(),
        ),
      );
    }
    weakAreas.sort((a, b) => b.severityGap.compareTo(a.severityGap));
    final topWeak = weakAreas.take(3).toList();
    final recommendations = RecommendationEngine.generate(
      RecommendationInput(
        readiness: readiness,
        weakAreas: topWeak,
        examCount: scores.length,
        coverage: progress.coverage,
        daysSinceActivity: lastActivity == null
            ? null
            : now.difference(lastActivity).inDays,
      ),
    );
    return PremiumAnalyticsModel(
      readiness: readiness,
      weakAreas: topWeak,
      recommendations: recommendations,
      examScores: scores,
    );
  }
}
