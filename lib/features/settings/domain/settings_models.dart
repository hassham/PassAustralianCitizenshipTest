import '../../../core/services/performance_monitor.dart';

class SettingsInfoModel {
  const SettingsInfoModel({
    required this.appVersion,
    required this.buildNumber,
    required this.questionBankVersion,
    required this.questionBankGeneratedAt,
    required this.sourceTitle,
    required this.sourceEdition,
    required this.sourcePublisher,
    required this.copyrightNotice,
    required this.licenceName,
    required this.licenceUrl,
    required this.disclaimer,
    required this.freeSpace,
    required this.lowOnSpace,
    required this.performanceSamples,
    required this.residentMemoryBytes,
  });

  final String appVersion;
  final String buildNumber;
  final String questionBankVersion;
  final DateTime? questionBankGeneratedAt;
  final String sourceTitle;
  final String sourceEdition;
  final String sourcePublisher;
  final String copyrightNotice;
  final String licenceName;
  final String licenceUrl;
  final String disclaimer;
  final String? freeSpace;
  final bool lowOnSpace;
  final List<PerformanceSample> performanceSamples;
  final int? residentMemoryBytes;
}
