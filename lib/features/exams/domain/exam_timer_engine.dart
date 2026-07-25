class ExamTimerSnapshot {
  const ExamTimerSnapshot({
    required this.remainingSeconds,
    required this.observedAt,
    required this.locked,
  });

  final int remainingSeconds;
  final DateTime observedAt;
  final bool locked;
  bool get expired => remainingSeconds <= 0;
}

abstract final class ExamTimerEngine {
  static ExamTimerSnapshot advance({
    required int remainingSeconds,
    required DateTime lastObservedAt,
    required DateTime now,
    bool locked = false,
  }) {
    if (locked) {
      return ExamTimerSnapshot(
        remainingSeconds: remainingSeconds,
        observedAt: lastObservedAt,
        locked: true,
      );
    }
    if (now.isBefore(lastObservedAt)) {
      return ExamTimerSnapshot(
        remainingSeconds: remainingSeconds,
        observedAt: lastObservedAt,
        locked: true,
      );
    }
    final elapsed = now.difference(lastObservedAt).inSeconds;
    return ExamTimerSnapshot(
      remainingSeconds: (remainingSeconds - elapsed).clamp(0, remainingSeconds),
      observedAt: now,
      locked: false,
    );
  }

  static String warningFor(int remainingSeconds) {
    if (remainingSeconds <= 60) return '1 minute remaining';
    if (remainingSeconds <= 300) return '5 minutes remaining';
    if (remainingSeconds <= 600) return '10 minutes remaining';
    return '';
  }
}
