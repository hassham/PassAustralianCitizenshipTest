import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_failure.dart';
import '../../../shared/presentation/failure_view.dart';
import '../../exams/application/exam_controller.dart';
import '../../progress/application/progress_providers.dart';
import '../../practice/application/practice_controller.dart';
import '../application/settings_providers.dart';
import '../domain/settings_models.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(settingsInfoProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: info.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => FailureView(
              failure: AppFailure.from(error),
              onRetry: () => ref.invalidate(settingsInfoProvider),
            ),
            data: (value) => _SettingsView(info: value),
          ),
        ),
      ),
    );
  }
}

class _SettingsView extends ConsumerWidget {
  const _SettingsView({required this.info});
  final SettingsInfoModel info;

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(action),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _invalidateUserData(WidgetRef ref) {
    ref.invalidate(progressProvider);
    ref.invalidate(progressAnalyticsProvider);
    ref.invalidate(premiumAnalyticsProvider);
    ref.invalidate(homeDashboardProvider);
    ref.invalidate(starredQuestionsProvider);
    ref.invalidate(removedStarredQuestionsProvider);
    ref.invalidate(settingsInfoProvider);
  }

  Future<void> _resetProgress(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirm(
      context,
      title: 'Reset progress?',
      message:
          'Practice attempts, sessions, and exam history will be deleted. '
          'Starred questions will be preserved.',
      action: 'Reset progress',
    );
    if (!confirmed) return;
    await ref.read(settingsRepositoryProvider).resetProgress();
    ref.read(practiceControllerProvider.notifier).reset();
    ref.read(examControllerProvider.notifier).reset();
    _invalidateUserData(ref);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress and exam history were reset.')),
      );
    }
  }

  Future<void> _clearStars(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirm(
      context,
      title: 'Clear starred questions?',
      message: 'All starred-question shortcuts will be removed.',
      action: 'Clear starred',
    );
    if (!confirmed) return;
    await ref.read(settingsRepositoryProvider).clearStarredQuestions();
    _invalidateUserData(ref);
  }

  Future<void> _refreshContent(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirm(
      context,
      title: 'Refresh question bank?',
      message:
          'Bundled questions and references will be imported again. Your '
          'progress and starred questions will be preserved.',
      action: 'Refresh content',
    );
    if (!confirmed) return;
    await ref.read(settingsRepositoryProvider).refreshContent();
    ref.invalidate(categoriesProvider);
    _invalidateUserData(ref);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Question bank refreshed.')));
    }
  }

  Future<void> _open(
    BuildContext context,
    Future<bool> Function() action,
  ) async {
    final opened = await action();
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The link could not be opened.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
    children: [
      if (info.lowOnSpace)
        Card(
          color: Theme.of(context).colorScheme.errorContainer,
          child: const ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Device storage is running low'),
            subtitle: Text(
              'Free some space before importing content or creating backups.',
            ),
          ),
        ),
      const _SectionHeader('Study content'),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Question bank'),
              subtitle: Text(
                'Version ${info.questionBankVersion}\n'
                '${info.sourceEdition}',
              ),
              isThreeLine: true,
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh bundled content'),
              subtitle: const Text('Preserves progress and starred questions'),
              onTap: () => _refreshContent(context, ref),
            ),
          ],
        ),
      ),
      const _SectionHeader('Data'),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Reset progress'),
              subtitle: const Text(
                'Deletes attempts, sessions, and exam history',
              ),
              onTap: () => _resetProgress(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Clear starred questions'),
              onTap: () => _clearStars(context, ref),
            ),
          ],
        ),
      ),
      const _SectionHeader('Information'),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App version'),
              trailing: Text('${info.appVersion}+${info.buildNumber}'),
            ),
            ListTile(
              leading: const Icon(Icons.policy_outlined),
              title: const Text('Privacy policy'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(
                context,
                ref.read(settingsRepositoryProvider).openPrivacyPolicy,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Support and report an issue'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(
                context,
                ref.read(settingsRepositoryProvider).openSupport,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.copyright),
              title: Text(info.licenceName),
              subtitle: Text(info.copyrightNotice),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(
                context,
                () => ref
                    .read(settingsRepositoryProvider)
                    .openLicence(info.licenceUrl),
              ),
            ),
          ],
        ),
      ),
      const _SectionHeader('Source and disclaimer'),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.sourceTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(info.sourcePublisher),
              const SizedBox(height: 12),
              Text(info.disclaimer),
            ],
          ),
        ),
      ),
      const _SectionHeader('Device diagnostics'),
      Card(
        child: ExpansionTile(
          leading: const Icon(Icons.monitor_heart_outlined),
          title: const Text('Performance and storage'),
          subtitle: Text(
            info.freeSpace == null
                ? _memoryLabel(info.residentMemoryBytes)
                : '${info.freeSpace} free · '
                      '${_memoryLabel(info.residentMemoryBytes)}',
          ),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          children: [
            if (info.performanceSamples.isEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Measurements appear after features are used.'),
              )
            else
              ...info.performanceSamples.map(
                (sample) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(sample.name.replaceAll('_', ' ')),
                  trailing: Text('${sample.elapsed.inMilliseconds} ms'),
                ),
              ),
          ],
        ),
      ),
    ],
  );

  String _memoryLabel(int? bytes) {
    if (bytes == null) return 'Memory information unavailable';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB app memory';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
    child: Text(label, style: Theme.of(context).textTheme.titleMedium),
  );
}
