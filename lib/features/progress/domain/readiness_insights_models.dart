class DifficultyPerformance {
  const DifficultyPerformance(this.attempts, this.correct);
  final int attempts;
  final int correct;
  double get accuracy => attempts == 0 ? 0 : correct * 100 / attempts;
}

class ReadinessInput {
  const ReadinessInput({
    required this.practiceAttempts,
    required this.practiceCorrect,
    required this.examScores,
    required this.activeCategories,
    required this.masteredCategories,
    required this.totalCategories,
    required this.easy,
    required this.medium,
    required this.hard,
    required this.lastActivityAt,
    required this.now,
    this.categoryAttempts = const {},
    this.recentAustralianValuesAnswers = const [],
    this.qualifyingMockResults = const [],
  });

  final int practiceAttempts;
  final int practiceCorrect;
  final List<double> examScores;
  final int activeCategories;
  final int masteredCategories;
  final int totalCategories;
  final DifficultyPerformance easy;
  final DifficultyPerformance medium;
  final DifficultyPerformance hard;
  final DateTime? lastActivityAt;
  final DateTime now;
  final Map<String, int> categoryAttempts;
  final List<bool> recentAustralianValuesAnswers;
  final List<bool> qualifyingMockResults;
}

class ReadinessResult {
  const ReadinessResult({
    required this.score,
    required this.label,
    required this.hasEnoughData,
    required this.hasMockExam,
    required this.trend,
    this.uncappedScore,
    this.appliedCap,
    this.capReason,
    this.nextAction,
    this.incompleteCategories = const {},
  });

  final int? score;
  final String label;
  final bool hasEnoughData;
  final bool hasMockExam;
  final double trend;
  final int? uncappedScore;
  final int? appliedCap;
  final String? capReason;
  final String? nextAction;
  final Map<String, int> incompleteCategories;
}

class WeakAreaModel {
  const WeakAreaModel({
    required this.categoryId,
    required this.categoryName,
    required this.accuracy,
    required this.targetAccuracy,
    required this.severityGap,
    required this.frequentlyMissedQuestions,
  });

  final String categoryId;
  final String categoryName;
  final int accuracy;
  final int targetAccuracy;
  final double severityGap;
  final List<String> frequentlyMissedQuestions;
}

class ReadinessInsightsModel {
  const ReadinessInsightsModel({
    required this.readiness,
    required this.weakAreas,
    required this.recommendations,
    required this.examScores,
    required this.hasEnoughWeakAreaData,
  });

  final ReadinessResult readiness;
  final List<WeakAreaModel> weakAreas;
  final List<String> recommendations;
  final List<double> examScores;
  final bool hasEnoughWeakAreaData;
}
