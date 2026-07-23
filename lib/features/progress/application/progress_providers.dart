import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../practice/application/practice_controller.dart';
import '../data/progress_repository.dart';
import '../domain/progress_models.dart';

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(
    ref.watch(databaseProvider),
    ref.watch(practiceRepositoryProvider),
  ),
);

final progressAnalyticsProvider = FutureProvider<ProgressAnalyticsModel>(
  (ref) => ref.watch(progressRepositoryProvider).analytics(),
);
