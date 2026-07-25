import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/features/progress/domain/premium_analytics_models.dart';
import 'package:pass_citizenship_test/features/progress/domain/readiness_calculator.dart';

void main() {
  test('requires at least ten practice attempts', () {
    final result = ReadinessCalculator.calculate(
      _input(practiceAttempts: 9, practiceCorrect: 9),
    );

    expect(result.score, isNull);
    expect(result.hasEnoughData, isFalse);
  });

  test('matches the documented readiness example', () {
    final result = ReadinessCalculator.calculate(
      ReadinessInput(
        practiceAttempts: 150,
        practiceCorrect: 120,
        examScores: const [78, 81, 85],
        activeCategories: 6,
        masteredCategories: 3,
        totalCategories: 8,
        easy: const DifficultyPerformance(100, 90),
        medium: const DifficultyPerformance(100, 82),
        hard: const DifficultyPerformance(100, 75),
        lastActivityAt: DateTime.utc(2026, 7, 22),
        now: DateTime.utc(2026, 7, 24),
      ),
    );

    expect(result.score, 71);
    expect(result.label, 'Well Prepared');
    expect(result.hasMockExam, isTrue);
  });

  test('applies the missing mock exam confidence penalty', () {
    final withExam = ReadinessCalculator.calculate(
      _input(examScores: const [80]),
    );
    final withoutExam = ReadinessCalculator.calculate(_input());

    expect(withoutExam.score!, lessThan(withExam.score!));
    expect(withoutExam.hasMockExam, isFalse);
  });
}

ReadinessInput _input({
  int practiceAttempts = 20,
  int practiceCorrect = 16,
  List<double> examScores = const [],
}) => ReadinessInput(
  practiceAttempts: practiceAttempts,
  practiceCorrect: practiceCorrect,
  examScores: examScores,
  activeCategories: 4,
  masteredCategories: 3,
  totalCategories: 4,
  easy: const DifficultyPerformance(5, 4),
  medium: const DifficultyPerformance(10, 8),
  hard: const DifficultyPerformance(5, 4),
  lastActivityAt: DateTime.utc(2026, 7, 24),
  now: DateTime.utc(2026, 7, 24),
);
