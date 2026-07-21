import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/practice_controller.dart';
import 'practice_screen.dart';
import 'starred_screen.dart';

class PracticeHubScreen extends ConsumerWidget {
  const PracticeHubScreen({super.key});

  Future<void> _start(
    BuildContext context,
    WidgetRef ref,
    String? categoryId,
  ) async {
    await ref.read(practiceControllerProvider.notifier).start(categoryId);
    if (context.mounted) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const PracticeScreen()));
      ref.invalidate(progressProvider);
      ref.invalidate(starredQuestionsProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final starred = ref.watch(starredQuestionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Choose how to practise',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _start(context, ref, null),
              icon: const Icon(Icons.play_arrow),
              label: const Text('All categories'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const StarredScreen()),
              ),
              icon: const Icon(Icons.star_outline),
              label: Text(
                starred.maybeWhen(
                  data: (items) => 'Starred questions (${items.length})',
                  orElse: () => 'Starred questions',
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text('Categories', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            categories.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Text('Categories could not be loaded: $error'),
              data: (items) => Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: ListTile(
                            title: Text(item.name),
                            subtitle: Text('${item.questionCount} questions'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _start(context, ref, item.id),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
