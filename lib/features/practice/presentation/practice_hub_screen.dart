import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/practice_controller.dart';
import '../domain/study_question.dart';
import 'practice_screen.dart';
import 'starred_screen.dart';

class PracticeHubScreen extends ConsumerStatefulWidget {
  const PracticeHubScreen({super.key});

  @override
  ConsumerState<PracticeHubScreen> createState() => _PracticeHubScreenState();
}

class _PracticeHubScreenState extends ConsumerState<PracticeHubScreen> {
  final selectedCategoryIds = <String>{};
  int selectedQuestionCount = 0;
  bool selectionInitialised = false;

  Future<void> _start(List<CategoryModel> categories) async {
    if (selectedCategoryIds.isEmpty) return;
    final allSelected = selectedCategoryIds.length == categories.length;
    await ref
        .read(practiceControllerProvider.notifier)
        .startSelection(
          categoryIds: allSelected ? null : selectedCategoryIds,
          questionCount: selectedQuestionCount == 0
              ? null
              : selectedQuestionCount,
        );
    if (mounted) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const PracticeScreen()));
      ref.invalidate(progressProvider);
      ref.invalidate(starredQuestionsProvider);
    }
  }

  void _initialiseSelection(List<CategoryModel> categories) {
    if (selectionInitialised) return;
    selectedCategoryIds.addAll(categories.map((category) => category.id));
    selectionInitialised = true;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final starred = ref.watch(starredQuestionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: SafeArea(
        child: categories.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Categories could not be loaded: $error'),
            ),
          ),
          data: (items) {
            _initialiseSelection(items);
            final allSelected =
                items.isNotEmpty && selectedCategoryIds.length == items.length;
            final availableQuestions = items
                .where((category) => selectedCategoryIds.contains(category.id))
                .fold<int>(
                  0,
                  (total, category) => total + category.questionCount,
                );
            final actualCount = selectedQuestionCount == 0
                ? availableQuestions
                : selectedQuestionCount.clamp(0, availableQuestions);
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Build a practice session',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose one or more categories and a session length.',
                ),
                const SizedBox(height: 24),
                Card(
                  child: SwitchListTile(
                    title: const Text('All categories'),
                    subtitle: Text('${items.length} categories'),
                    value: allSelected,
                    onChanged: (selected) => setState(() {
                      selectedCategoryIds.clear();
                      if (selected) {
                        selectedCategoryIds.addAll(
                          items.map((category) => category.id),
                        );
                      }
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: CheckboxListTile(
                        title: Text(category.name),
                        subtitle: Text('${category.questionCount} questions'),
                        value: selectedCategoryIds.contains(category.id),
                        onChanged: (selected) => setState(() {
                          if (selected ?? false) {
                            selectedCategoryIds.add(category.id);
                          } else {
                            selectedCategoryIds.remove(category.id);
                          }
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Number of questions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [0, 5, 10, 20]
                      .map(
                        (count) => ChoiceChip(
                          label: Text(count == 0 ? 'All available' : '$count'),
                          selected: selectedQuestionCount == count,
                          onSelected: (_) =>
                              setState(() => selectedQuestionCount = count),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  selectedCategoryIds.isEmpty
                      ? 'Select at least one category.'
                      : '$actualCount question${actualCount == 1 ? '' : 's'} will be included.',
                  style: TextStyle(
                    color: selectedCategoryIds.isEmpty
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: selectedCategoryIds.isEmpty || actualCount == 0
                      ? null
                      : () => _start(items),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start practice'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const StarredScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.star_outline),
                  label: Text(
                    starred.maybeWhen(
                      data: (questions) =>
                          'Starred questions (${questions.length})',
                      orElse: () => 'Starred questions',
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
