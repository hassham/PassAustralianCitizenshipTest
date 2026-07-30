import '../../../core/services/app_logger.dart';
import '../../../core/services/performance_monitor.dart';
import '../../../data/database/app_database.dart';
import '../../practice/data/practice_repository.dart';
import '../domain/progress_models.dart';

class ProgressRepository {
  const ProgressRepository(this.database, this.practiceRepository);

  final AppDatabase database;
  final PracticeRepository practiceRepository;

  Future<ProgressAnalyticsModel> analytics() {
    return PerformanceMonitor.measure(
      'progress_analytics',
      _calculateAnalytics,
      warningThreshold: const Duration(milliseconds: 100),
    );
  }

  Future<ProgressAnalyticsModel> _calculateAnalytics() async {
    await practiceRepository.initialise();
    final categoryRows = await database.select(database.categories).get();
    final questionRows = await database.select(database.studyQuestions).get();
    final removedIds =
        (await database
                .customSelect('SELECT question_id FROM removed_questions')
                .get())
            .map((row) => row.read<String>('question_id'))
            .toSet();
    final activeQuestions = questionRows
        .where((question) => !removedIds.contains(question.id))
        .toList();
    final questionCategory = {
      for (final question in questionRows) question.id: question.categoryId,
    };
    final attempts = await database.select(database.questionAttempts).get();
    final sessions = await database.select(database.practiceSessions).get();
    final exams = await (database.select(
      database.examAttempts,
    )..where((row) => row.submittedAt.isNotNull())).get();
    final completedExamIds = exams.map((exam) => exam.id).toSet();
    final examSubmittedAt = {
      for (final exam in exams) exam.id: exam.submittedAt!,
    };
    final examAnswers =
        (await database.select(database.examAttemptAnswers).get())
            .where((answer) => completedExamIds.contains(answer.examAttemptId))
            .toList();
    final now = DateTime.now();
    final recentCutoff = now.subtract(const Duration(days: 7));

    final categories =
        categoryRows.map((category) {
          final categoryAttempts = attempts
              .where(
                (attempt) =>
                    questionCategory[attempt.questionId] == category.id,
              )
              .toList();
          final categoryQuestionCount = activeQuestions
              .where((question) => question.categoryId == category.id)
              .length;
          final categoryExamAnswers = examAnswers
              .where(
                (answer) => questionCategory[answer.questionId] == category.id,
              )
              .toList();
          categoryAttempts.sort(
            (left, right) => right.attemptedAt.compareTo(left.attemptedAt),
          );
          final combinedQuestionIds = {
            ...categoryAttempts.map((attempt) => attempt.questionId),
            ...categoryExamAnswers.map((answer) => answer.questionId),
          };
          final lastPracticeAt = categoryAttempts.isEmpty
              ? null
              : categoryAttempts.first.attemptedAt;
          final lastExamAt = categoryExamAnswers
              .map((answer) => examSubmittedAt[answer.examAttemptId])
              .whereType<DateTime>()
              .fold<DateTime?>(
                null,
                (latest, date) =>
                    latest == null || date.isAfter(latest) ? date : latest,
              );
          return CategoryPerformanceModel(
            categoryId: category.id,
            categoryName: category.name,
            attempted: categoryAttempts.length + categoryExamAnswers.length,
            correct:
                categoryAttempts.where((attempt) => attempt.isCorrect).length +
                categoryExamAnswers
                    .where((answer) => answer.isCorrect == true)
                    .length,
            uniqueQuestions: combinedQuestionIds
                .intersection(
                  activeQuestions
                      .where((question) => question.categoryId == category.id)
                      .map((question) => question.id)
                      .toSet(),
                )
                .length,
            totalQuestions: categoryQuestionCount,
            lastAttemptedAt: lastPracticeAt == null
                ? lastExamAt
                : lastExamAt == null || lastPracticeAt.isAfter(lastExamAt)
                ? lastPracticeAt
                : lastExamAt,
          );
        }).toList()..sort((left, right) {
          if (left.attempted == 0 && right.attempted != 0) return 1;
          if (right.attempted == 0 && left.attempted != 0) return -1;
          return left.accuracy.compareTo(right.accuracy);
        });

    final activity = <DailyActivityModel>[];
    for (var daysAgo = 6; daysAgo >= 0; daysAgo--) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: daysAgo));
      final nextDay = day.add(const Duration(days: 1));
      activity.add(
        DailyActivityModel(
          day,
          attempts
              .where(
                (attempt) =>
                    !attempt.attemptedAt.isBefore(day) &&
                    attempt.attemptedAt.isBefore(nextDay),
              )
              .length,
        ),
      );
    }
    final lastActivityAt = attempts.isEmpty
        ? null
        : attempts
              .map((attempt) => attempt.attemptedAt)
              .reduce((left, right) => left.isAfter(right) ? left : right);
    AppLogger.info(
      'Progress analytics calculated',
      fields: {
        'attempts': attempts.length,
        'categories': categories.length,
        'activeQuestions': activeQuestions.length,
      },
    );
    return ProgressAnalyticsModel(
      attempted: attempts.length,
      correct: attempts.where((attempt) => attempt.isCorrect).length,
      uniqueQuestions: attempts
          .map((attempt) => attempt.questionId)
          .toSet()
          .intersection(activeQuestions.map((question) => question.id).toSet())
          .length,
      totalQuestions: activeQuestions.length,
      practiceSessions: sessions.where((session) => session.isComplete).length,
      examAttempts: exams.length,
      recentAnswers: attempts
          .where((attempt) => attempt.attemptedAt.isAfter(recentCutoff))
          .length,
      lastActivityAt: lastActivityAt,
      categories: categories,
      activity: activity,
    );
  }
}
