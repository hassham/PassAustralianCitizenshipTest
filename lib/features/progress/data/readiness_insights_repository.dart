import 'package:drift/drift.dart';

import '../../../core/services/performance_monitor.dart';
import '../../../data/database/app_database.dart';
import '../../practice/data/practice_repository.dart';
import '../domain/readiness_insights_models.dart';
import '../domain/readiness_calculator.dart';
import '../domain/recommendation_engine.dart';
import 'progress_repository.dart';

class ReadinessInsightsRepository {
  const ReadinessInsightsRepository(
    this.database,
    this.practiceRepository,
    this.progressRepository,
  );

  final AppDatabase database;
  final PracticeRepository practiceRepository;
  final ProgressRepository progressRepository;

  Future<ReadinessInsightsModel> analytics({DateTime? now}) =>
      PerformanceMonitor.measure(
        'readiness_insights',
        () => _calculate(now ?? DateTime.now()),
        warningThreshold: const Duration(milliseconds: 150),
      );

  Future<ReadinessInsightsModel> _calculate(DateTime now) async {
    await practiceRepository.initialise();
    final progress = await progressRepository.analytics();
    final attempts = await database.select(database.questionAttempts).get();
    final questions = await database.select(database.studyQuestions).get();
    final metadata = await database
        .customSelect(
          'SELECT question_id, difficulty, is_australian_values '
          'FROM question_metadata',
        )
        .get();
    final difficultyByQuestion = {
      for (final row in metadata)
        row.read<String>('question_id'): row.read<String>('difficulty'),
    };
    final isAustralianValues = {
      for (final row in metadata)
        row.read<String>('question_id'):
            row.read<int>('is_australian_values') == 1,
    };
    final exams =
        await (database.select(database.examAttempts)
              ..where((row) => row.submittedAt.isNotNull())
              ..orderBy([(row) => OrderingTerm.asc(row.submittedAt)]))
            .get();
    final scores = exams.map((exam) => exam.score ?? 0).toList();
    final examAnswers = await database.select(database.examAttemptAnswers).get();
    final configurations = await database
        .select(database.examConfigurations)
        .get();
    final passMarkByConfig = {
      for (final config in configurations) config.id: config.passPercentage,
    };
    final qualifyingMockResults = [
      for (final exam in exams)
        _isQualifyingMock(
          exam,
          examAnswers
              .where((answer) => answer.examAttemptId == exam.id)
              .toList(),
          isAustralianValues,
          passMarkByConfig[exam.configId] ?? 75,
        ),
    ];
    final recentValuesAnswers =
        attempts
            .where(
              (attempt) => isAustralianValues[attempt.questionId] ?? false,
            )
            .toList()
          ..sort(
            (left, right) => right.attemptedAt.compareTo(left.attemptedAt),
          );
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
        categoryAttempts: {
          for (final category in progress.categories)
            category.categoryName: category.attempted,
        },
        recentAustralianValuesAnswers: recentValuesAnswers
            .take(5)
            .map((attempt) => attempt.isCorrect)
            .toList(),
        qualifyingMockResults: qualifyingMockResults,
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
      if (category.attempted < 10 || category.accuracy >= threshold) continue;
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
    return ReadinessInsightsModel(
      readiness: readiness,
      weakAreas: topWeak,
      recommendations: recommendations,
      examScores: scores,
      hasEnoughWeakAreaData: progress.categories.isNotEmpty &&
          progress.categories.every((category) => category.attempted >= 10),
    );
  }

  bool _isQualifyingMock(
    ExamAttempt exam,
    List<ExamAttemptAnswer> answers,
    Map<String, bool> isAustralianValues,
    double passMark,
  ) {
    final valuesAnswers = answers
        .where(
          (answer) => isAustralianValues[answer.questionId] ?? false,
        )
        .toList();
    final valuesCorrect = valuesAnswers
        .where((answer) => answer.isCorrect == true)
        .length;
    return (exam.score ?? 0) >= passMark &&
        valuesAnswers.length == 5 &&
        valuesCorrect == 5;
  }
}
