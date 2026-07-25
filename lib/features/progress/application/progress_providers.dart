import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../practice/application/practice_controller.dart';
import '../data/progress_repository.dart';
import '../data/premium_analytics_repository.dart';
import '../domain/premium_analytics_models.dart';
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

final premiumAnalyticsRepositoryProvider = Provider<PremiumAnalyticsRepository>(
  (ref) => PremiumAnalyticsRepository(
    ref.watch(databaseProvider),
    ref.watch(practiceRepositoryProvider),
    ref.watch(progressRepositoryProvider),
  ),
);

final premiumAnalyticsProvider = FutureProvider<PremiumAnalyticsModel>(
  (ref) => ref.watch(premiumAnalyticsRepositoryProvider).analytics(),
);
