import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/app.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/practice/application/practice_controller.dart';

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

  testWidgets('provides five-section navigation and opens starred questions', (
    tester,
  ) async {
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

    await tester.tap(find.byIcon(Icons.school_outlined));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Choose how to practise'), findsOneWidget);

    await tester.tap(find.textContaining('Starred questions'));
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Starred questions'), findsOneWidget);
  });
}
