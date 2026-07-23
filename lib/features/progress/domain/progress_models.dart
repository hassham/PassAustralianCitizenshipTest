enum PerformanceBand { strong, developing, weak, notStarted }

class CategoryPerformanceModel {
  const CategoryPerformanceModel({
    required this.categoryId,
    required this.categoryName,
    required this.attempted,
    required this.correct,
    required this.uniqueQuestions,
    required this.totalQuestions,
    required this.lastAttemptedAt,
  });

  final String categoryId;
  final String categoryName;
  final int attempted;
  final int correct;
  final int uniqueQuestions;
  final int totalQuestions;
  final DateTime? lastAttemptedAt;

  int get accuracy => attempted == 0 ? 0 : (correct * 100 / attempted).round();
  int get coverage => totalQuestions == 0
      ? 0
      : (uniqueQuestions * 100 / totalQuestions).clamp(0, 100).round();
  PerformanceBand get band {
    if (attempted == 0) return PerformanceBand.notStarted;
    if (attempted < 3) return PerformanceBand.developing;
    if (accuracy >= 80) return PerformanceBand.strong;
    if (accuracy < 60) return PerformanceBand.weak;
    return PerformanceBand.developing;
  }
}

class DailyActivityModel {
  const DailyActivityModel(this.date, this.answers);
  final DateTime date;
  final int answers;
}

class ProgressAnalyticsModel {
  const ProgressAnalyticsModel({
    required this.attempted,
    required this.correct,
    required this.uniqueQuestions,
    required this.totalQuestions,
    required this.practiceSessions,
    required this.examAttempts,
    required this.recentAnswers,
    required this.lastActivityAt,
    required this.categories,
    required this.activity,
  });

  final int attempted;
  final int correct;
  final int uniqueQuestions;
  final int totalQuestions;
  final int practiceSessions;
  final int examAttempts;
  final int recentAnswers;
  final DateTime? lastActivityAt;
  final List<CategoryPerformanceModel> categories;
  final List<DailyActivityModel> activity;

  int get incorrect => attempted - correct;
  int get accuracy => attempted == 0 ? 0 : (correct * 100 / attempted).round();
  int get coverage => totalQuestions == 0
      ? 0
      : (uniqueQuestions * 100 / totalQuestions).clamp(0, 100).round();
  List<CategoryPerformanceModel> get strongCategories =>
      categories.where((item) => item.band == PerformanceBand.strong).toList();
  List<CategoryPerformanceModel> get weakCategories =>
      categories.where((item) => item.band == PerformanceBand.weak).toList();
}
