import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/practice_controller.dart';
import 'practice_screen.dart';

class StarredScreen extends ConsumerWidget {
  const StarredScreen({super.key});

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    final started = await ref
        .read(practiceControllerProvider.notifier)
        .startStarred();
    if (started && context.mounted) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const PracticeScreen()));
      ref.invalidate(starredQuestionsProvider);
      ref.invalidate(progressProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final starred = ref.watch(starredQuestionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Starred questions')),
      body: SafeArea(
        child: starred.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Starred questions could not be loaded: $error'),
          ),
          data: (questions) {
            if (questions.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_outline, size: 72),
                      SizedBox(height: 16),
                      Text(
                        'No starred questions yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the star while practising to save a question for focused revision.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  '${questions.length} saved',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _start(context, ref),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Practise starred questions'),
                ),
                const SizedBox(height: 20),
                ...questions.map(
                  (question) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.star,
                          color: Color(0xFFF0A000),
                        ),
                        title: Text(question.text),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
