import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../practice/application/practice_controller.dart';
import '../data/settings_repository.dart';
import '../domain/settings_models.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(
    ref.watch(databaseProvider),
    ref.watch(practiceRepositoryProvider),
  ),
);

final settingsInfoProvider = FutureProvider<SettingsInfoModel>(
  (ref) => ref.watch(settingsRepositoryProvider).info(),
);
