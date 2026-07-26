import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/features/progress/domain/readiness_insights_models.dart';
import 'package:pass_citizenship_test/features/progress/domain/recommendation_engine.dart';

void main() {
  test('prioritizes trying an exam when no exam exists', () {
    final result = RecommendationEngine.generate(
      _input(examCount: 0, coverage: 100, daysSinceActivity: 0),
    );

    expect(result.first, 'Try a mock exam to test your knowledge.');
  });

  test('recommends the weakest category and low coverage', () {
    final weak = WeakAreaModel(
      categoryId: 'history',
      categoryName: 'Australian history',
      accuracy: 40,
      targetAccuracy: 65,
      severityGap: 25,
      frequentlyMissedQuestions: const [],
    );
    final result = RecommendationEngine.generate(
      _input(weakAreas: [weak], examCount: 1, coverage: 50),
    );

    expect(result.any((item) => item.contains('Australian history')), isTrue);
    expect(result.any((item) => item.contains('Explore more')), isTrue);
  });

  test('recognizes a highly ready user with three exams', () {
    final result = RecommendationEngine.generate(
      RecommendationInput(
        readiness: const ReadinessResult(
          score: 85,
          label: 'Very Well Prepared',
          hasEnoughData: true,
          hasMockExam: true,
          trend: 7,
        ),
        weakAreas: const [],
        examCount: 3,
        coverage: 100,
        daysSinceActivity: 0,
      ),
    );

    expect(result.first, contains('well prepared'));
  });
}

RecommendationInput _input({
  List<WeakAreaModel> weakAreas = const [],
  int examCount = 1,
  int coverage = 100,
  int? daysSinceActivity = 0,
}) => RecommendationInput(
  readiness: const ReadinessResult(
    score: 55,
    label: 'Making Progress',
    hasEnoughData: true,
    hasMockExam: true,
    trend: 0,
  ),
  weakAreas: weakAreas,
  examCount: examCount,
  coverage: coverage,
  daysSinceActivity: daysSinceActivity,
);
