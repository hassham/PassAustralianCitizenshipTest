import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/features/exams/domain/exam_timer_engine.dart';

void main() {
  test('subtracts real elapsed time from the persisted timer', () {
    final start = DateTime.utc(2026, 7, 24, 10);
    final snapshot = ExamTimerEngine.advance(
      remainingSeconds: 2700,
      lastObservedAt: start,
      now: start.add(const Duration(minutes: 5, seconds: 4)),
    );

    expect(snapshot.remainingSeconds, 2396);
    expect(snapshot.expired, isFalse);
    expect(snapshot.locked, isFalse);
  });

  test('expires without allowing a negative remaining time', () {
    final start = DateTime.utc(2026, 7, 24, 10);
    final snapshot = ExamTimerEngine.advance(
      remainingSeconds: 30,
      lastObservedAt: start,
      now: start.add(const Duration(minutes: 1)),
    );

    expect(snapshot.remainingSeconds, 0);
    expect(snapshot.expired, isTrue);
  });

  test('locks when the device clock moves backwards', () {
    final observed = DateTime.utc(2026, 7, 24, 10);
    final snapshot = ExamTimerEngine.advance(
      remainingSeconds: 1200,
      lastObservedAt: observed,
      now: observed.subtract(const Duration(minutes: 2)),
    );

    expect(snapshot.remainingSeconds, 1200);
    expect(snapshot.locked, isTrue);
  });
}
