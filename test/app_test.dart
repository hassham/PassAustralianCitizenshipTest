import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/app.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/practice/application/practice_controller.dart';
import 'package:pass_citizenship_test/features/practice/domain/study_question.dart';
import 'package:pass_citizenship_test/features/practice/presentation/practice_hub_screen.dart';

void main() {
  testWidgets('shows the offline practice entry point', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const CitizenshipStudyApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Learn with confidence'), findsOneWidget);
    expect(find.text('Practice all categories'), findsOneWidget);
    expect(find.text('Australian values'), findsOneWidget);
  });

  testWidgets('provides five-section navigation', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const CitizenshipStudyApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Exams'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('practice hub supports category and question-count selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesProvider.overrideWith(
            (_) async => const [
              CategoryModel('values', 'Australian values', 4),
              CategoryModel('history', 'Australia and its people', 4),
            ],
          ),
          starredQuestionsProvider.overrideWith((_) async => const []),
        ],
        child: const MaterialApp(home: PracticeHubScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Build a practice session'), findsOneWidget);
    expect(find.text('8 questions will be included.'), findsOneWidget);

    await tester.tap(find.text('Australia and its people'));
    await tester.pump();
    expect(find.text('4 questions will be included.'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();
    expect(find.text('4 questions will be included.'), findsOneWidget);
  });
}
