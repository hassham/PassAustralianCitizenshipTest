import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/services/app_logger.dart';
import 'core/services/performance_monitor.dart';

Future<void> main() async {
  final startup = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: CitizenshipStudyApp()));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    startup.stop();
    PerformanceMonitor.record(
      'app_first_frame',
      startup.elapsed,
      warningThreshold: const Duration(seconds: 1),
    );
    AppLogger.info(
      'First frame rendered',
      fields: {'elapsedMs': startup.elapsedMilliseconds},
    );
  });
}
