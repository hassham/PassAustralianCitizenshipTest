import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/routing/app_routes.dart';
import '../application/exam_controller.dart';

class ExamsHomeScreen extends ConsumerStatefulWidget {
  const ExamsHomeScreen({super.key});

  @override
  ConsumerState<ExamsHomeScreen> createState() => _ExamsHomeScreenState();
}

class _ExamsHomeScreenState extends ConsumerState<ExamsHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(examControllerProvider.notifier).restore();
    });
  }

  Future<void> _startExam() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start untimed mock exam?'),
        content: const Text(
          'Answers are not marked until you submit. You can move backward, '
          'forward, and return after closing the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start exam'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(examControllerProvider.notifier).start();
    if (mounted) _openExam();
  }

  void _openExam() {
    context.pushNamed(AppRoutes.examSession);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(examControllerProvider);
    final config = ref.watch(examConfigProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mock exams')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Test your knowledge',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a realistic untimed exam. Your answers are scored only '
              'after submission.',
            ),
            const SizedBox(height: 24),
            if (state.loading)
              const LinearProgressIndicator()
            else if (state.active)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Exam in progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${state.answers.length} of ${state.questions.length} answered',
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _openExam,
                        child: const Text('Continue exam'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.fact_check_outlined, size: 42),
                    const SizedBox(height: 12),
                    Text(
                      'Free untimed exam',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    config.when(
                      loading: () => const Text('Loading exam rules…'),
                      error: (error, _) => Text(AppFailure.from(error).message),
                      data: (value) => Text(
                        'Up to ${value.questionCount} questions • '
                        '${value.passPercentage.toStringAsFixed(0)}% pass mark • No timer',
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: state.loading ? null : _startExam,
                      child: const Text('Start new exam'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.pushNamed(AppRoutes.examHistory),
              icon: const Icon(Icons.history),
              label: const Text('View completed exams'),
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Timed exam'),
                subtitle: Text('Coming with Premium'),
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.error!.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(state.error!.message),
                      TextButton(
                        onPressed: () =>
                            ref.read(examControllerProvider.notifier).restore(),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
