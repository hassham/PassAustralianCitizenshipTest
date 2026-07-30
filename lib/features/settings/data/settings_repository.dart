import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storage_space/storage_space.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/app_logger.dart';
import '../../../core/services/performance_monitor.dart';
import '../../../core/services/runtime_memory.dart';
import '../../../data/database/app_database.dart';
import '../../practice/data/practice_repository.dart';
import '../domain/settings_models.dart';

class SettingsRepository {
  const SettingsRepository(this.database, this.practiceRepository);

  static final privacyUri = Uri.parse(
    'https://github.com/hassham/PassAustralianCitizenshipTest/blob/master/PRIVACY.md',
  );
  static final supportUri = Uri.parse(
    'https://github.com/hassham/PassAustralianCitizenshipTest/issues',
  );
  static final buyMeACoffeeUri = Uri.parse(
    const String.fromEnvironment(
      'BUY_ME_A_COFFEE_URL',
      defaultValue: 'https://www.buymeacoffee.com/hashamahmad',
    ),
  );

  final AppDatabase database;
  final PracticeRepository practiceRepository;

  Future<SettingsInfoModel> info() async {
    await practiceRepository.initialise();
    final package = await PackageInfo.fromPlatform();
    final settings = await database.select(database.appSettings).get();
    final values = {for (final setting in settings) setting.key: setting.value};
    final attribution =
        jsonDecode(values['questions_attribution'] ?? '{}')
            as Map<String, dynamic>;
    final source = await database
        .customSelect(
          'SELECT title, publisher, edition FROM source_editions LIMIT 1',
        )
        .getSingleOrNull();
    String? freeSpace;
    var lowOnSpace = false;
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        final storage = await getStorageSpace(
          lowOnSpaceThreshold: 50 * 1024 * 1024,
          fractionDigits: 1,
        );
        freeSpace = storage.freeSize;
        lowOnSpace = storage.lowOnSpace;
      } catch (error) {
        AppLogger.warning(
          'Storage-space query was unavailable',
          fields: {'error': error.toString()},
        );
      }
    }
    return SettingsInfoModel(
      appVersion: package.version,
      buildNumber: package.buildNumber,
      questionBankVersion: values['questions_version'] ?? 'Unknown',
      questionBankGeneratedAt: DateTime.tryParse(
        values['questions_generated_at'] ?? '',
      ),
      sourceTitle: source?.read<String>('title') ?? 'Our Common Bond',
      sourceEdition: source?.read<String>('edition') ?? 'Unknown edition',
      sourcePublisher:
          source?.read<String>('publisher') ??
          'Australian Government, Department of Home Affairs',
      copyrightNotice:
          attribution['copyrightNotice'] as String? ??
          'Source material © Commonwealth of Australia.',
      licenceName:
          attribution['licenceName'] as String? ??
          'Creative Commons Attribution 4.0 International',
      licenceUrl:
          attribution['licenceUrl'] as String? ??
          'https://creativecommons.org/licenses/by/4.0/',
      disclaimer:
          attribution['disclaimer'] as String? ??
          'This is an unofficial study aid and is not endorsed by the '
              'Australian Government.',
      freeSpace: freeSpace,
      lowOnSpace: lowOnSpace,
      performanceSamples: PerformanceMonitor.latest,
      residentMemoryBytes: currentResidentMemoryBytes(),
    );
  }

  Future<void> resetProgress() async {
    await database.transaction(() async {
      await database.delete(database.questionAttempts).go();
      await database.delete(database.practiceSessions).go();
      await database.delete(database.examAttemptAnswers).go();
      await database.delete(database.examAttempts).go();
      await database.customStatement(
        "DELETE FROM answer_option_selections "
        "WHERE owner_type IN ('practice_attempt', 'exam_answer')",
      );
    });
    AppLogger.info('User progress reset');
  }

  Future<void> clearStarredQuestions() async {
    await database.delete(database.starredQuestions).go();
    AppLogger.info('Starred questions cleared');
  }

  Future<void> refreshContent() => practiceRepository.refreshBundledContent();

  Future<bool> openPrivacyPolicy() => _open(privacyUri);
  Future<bool> openSupport() => _open(supportUri);
  Future<bool> openBuyMeACoffee() => _open(buyMeACoffeeUri);
  Future<bool> openLicence(String url) => _open(Uri.parse(url));

  Future<bool> _open(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      AppLogger.warning(
        'External link could not be opened',
        fields: {'uri': uri.toString()},
      );
    }
    return opened;
  }
}
