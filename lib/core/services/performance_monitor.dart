import 'app_logger.dart';

class PerformanceSample {
  const PerformanceSample(this.name, this.elapsed, this.recordedAt);
  final String name;
  final Duration elapsed;
  final DateTime recordedAt;
}

abstract final class PerformanceMonitor {
  static final Map<String, PerformanceSample> _latest = {};

  static List<PerformanceSample> get latest =>
      _latest.values.toList()
        ..sort((left, right) => left.name.compareTo(right.name));

  static Future<T> measure<T>(
    String name,
    Future<T> Function() operation, {
    Duration warningThreshold = const Duration(milliseconds: 500),
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      return await operation();
    } finally {
      stopwatch.stop();
      final sample = PerformanceSample(name, stopwatch.elapsed, DateTime.now());
      _latest[name] = sample;
      final fields = {'elapsedMs': stopwatch.elapsedMilliseconds};
      if (stopwatch.elapsed > warningThreshold) {
        AppLogger.warning('$name exceeded its target', fields: fields);
      } else {
        AppLogger.debug('$name completed', fields: fields);
      }
    }
  }

  static T measureSync<T>(
    String name,
    T Function() operation, {
    Duration warningThreshold = const Duration(milliseconds: 100),
  }) {
    final stopwatch = Stopwatch()..start();
    try {
      return operation();
    } finally {
      stopwatch.stop();
      _latest[name] = PerformanceSample(
        name,
        stopwatch.elapsed,
        DateTime.now(),
      );
      if (stopwatch.elapsed > warningThreshold) {
        AppLogger.warning(
          '$name exceeded its target',
          fields: {'elapsedMs': stopwatch.elapsedMilliseconds},
        );
      }
    }
  }

  static void record(
    String name,
    Duration elapsed, {
    Duration warningThreshold = const Duration(milliseconds: 500),
  }) {
    _latest[name] = PerformanceSample(name, elapsed, DateTime.now());
    final fields = {'elapsedMs': elapsed.inMilliseconds};
    if (elapsed > warningThreshold) {
      AppLogger.warning('$name exceeded its target', fields: fields);
    } else {
      AppLogger.debug('$name completed', fields: fields);
    }
  }
}
