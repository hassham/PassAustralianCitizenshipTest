import 'readiness_insights_models.dart';

abstract final class ReadinessCalculator {
  static ReadinessResult calculate(ReadinessInput input) {
    if (input.practiceAttempts < 10) {
      return const ReadinessResult(
        score: null,
        label: 'Not enough data',
        hasEnoughData: false,
        hasMockExam: false,
        trend: 0,
      );
    }
    final baseAccuracy = input.practiceCorrect * 100 / input.practiceAttempts;
    final mockScore = input.examScores.isEmpty
        ? baseAccuracy * 0.5
        : input.examScores.reduce((a, b) => a + b) / input.examScores.length;
    final coverage = input.totalCategories == 0
        ? 0.0
        : input.activeCategories / input.totalCategories * 100 * 0.8;
    final mastery = input.totalCategories == 0
        ? 0.0
        : input.masteredCategories / input.totalCategories * 20;
    final difficulty =
        input.easy.accuracy * 0.2 +
        input.medium.accuracy * 0.4 +
        input.hard.accuracy * 0.4;
    final recency = _recency(input.lastActivityAt, input.now);
    final trend = _trend(input.examScores);
    var raw =
        baseAccuracy * 0.25 +
        mockScore * 0.30 +
        (coverage + mastery) * 0.20 +
        difficulty * 0.15 +
        recency * 0.05 +
        trend * 0.05;
    if (input.examScores.isEmpty) raw *= 0.7;
    final score = raw.clamp(0, 100).round();
    return ReadinessResult(
      score: score,
      label: labelFor(score),
      hasEnoughData: true,
      hasMockExam: input.examScores.isNotEmpty,
      trend: trend,
    );
  }

  static double _recency(DateTime? lastActivity, DateTime now) {
    if (lastActivity == null) return 0;
    final days = now.difference(lastActivity).inDays;
    if (days <= 1) return 10;
    if (days <= 3) return 7;
    if (days <= 7) return 3;
    return 0;
  }

  static double _trend(List<double> scores) {
    if (scores.length < 2) return 0;
    final difference = scores.last - scores.first;
    if (difference >= 10) return 10;
    if (difference >= 5) return 7;
    if (difference >= 0) return 3;
    return 0;
  }

  static String labelFor(int score) {
    if (score >= 90) return 'Ready For Test';
    if (score >= 80) return 'Very Well Prepared';
    if (score >= 70) return 'Well Prepared';
    if (score >= 60) return 'Moderately Prepared';
    if (score >= 50) return 'Making Progress';
    if (score >= 40) return 'Early Stage';
    return 'Build Foundation';
  }
}
