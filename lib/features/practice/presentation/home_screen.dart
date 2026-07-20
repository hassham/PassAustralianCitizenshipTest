import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../application/practice_controller.dart';
import '../domain/study_question.dart';
import 'practice_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _offerResume());
  }

  Future<void> _offerResume() async {
    final restored = await ref
        .read(practiceControllerProvider.notifier)
        .restore();
    if (!restored || !mounted) return;
    final resume = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Continue learning?'),
        content: const Text('Your unfinished practice session was saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (resume == true && mounted) _openPractice();
  }

  void _openPractice() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const PracticeScreen()))
        .then((_) => ref.invalidate(progressProvider));
  }

  Future<void> _start(String? categoryId) async {
    await ref.read(practiceControllerProvider.notifier).start(categoryId);
    if (mounted) _openPractice();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final progress = ref.watch(progressProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Citizenship Test Study')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Learn with confidence',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Short, focused practice that works completely offline.',
            ),
            const SizedBox(height: 24),
            progress.when(
              data: (value) => _ProgressCard(value: value),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _start(null),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Practice all categories'),
            ),
            const SizedBox(height: 28),
            Text(
              'Choose a category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            categories.when(
              data: (items) => Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            title: Text(item.name),
                            subtitle: Text(
                              '${item.questionCount} starter questions',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _start(item.id),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Content could not be loaded: $error'),
            ),
            const SizedBox(height: 20),
            const Text(
              AppConstants.sampleContentNotice,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.value});
  final ProgressSummary value;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(radius: 26, child: Icon(Icons.insights)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${value.accuracy}% accuracy',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('${value.attempted} questions answered'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
