import 'premium_analytics_models.dart';

class RecommendationInput {
  const RecommendationInput({
    required this.readiness,
    required this.weakAreas,
    required this.examCount,
    required this.coverage,
    required this.daysSinceActivity,
  });

  final ReadinessResult readiness;
  final List<WeakAreaModel> weakAreas;
  final int examCount;
  final int coverage;
  final int? daysSinceActivity;
}

abstract final class RecommendationEngine {
  static List<String> generate(RecommendationInput input) {
    final recommendations = <String>[];
    if (input.examCount == 0) {
      recommendations.add('Try a mock exam to test your knowledge.');
    }
    if (!input.readiness.hasEnoughData) {
      recommendations.add(
        'Complete at least 10 practice questions to calculate readiness.',
      );
    } else if ((input.readiness.score ?? 0) < 60) {
      recommendations.add(
        input.weakAreas.isEmpty
            ? 'Build your foundation with focused category practice.'
            : 'Focus on weak areas: ${input.weakAreas.map((area) => area.categoryName).join(', ')}.',
      );
    }
    if ((input.readiness.score ?? 0) >= 80 && input.examCount >= 3) {
      recommendations.add(
        "You're well prepared. Consider booking the official test.",
      );
    }
    if (input.weakAreas.isNotEmpty) {
      final weakest = input.weakAreas.first;
      recommendations.add(
        'Practice ${weakest.categoryName}: your accuracy is ${weakest.accuracy}%.',
      );
    }
    if (input.coverage < 70) {
      recommendations.add(
        'Explore more categories to build comprehensive knowledge.',
      );
    }
    if (input.daysSinceActivity == null || input.daysSinceActivity! >= 7) {
      recommendations.add('Keep your momentum. Continue practising.');
    }
    if (recommendations.isEmpty) {
      recommendations.add(
        'No significant weak areas detected. Keep practising across all categories.',
      );
    }
    return recommendations;
  }
}
