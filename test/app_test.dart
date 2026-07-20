import 'package:drift/native.dart';
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
    await tester.pumpAndSettle();

    expect(find.text('Learn with confidence'), findsOneWidget);
    expect(find.text('Practice all categories'), findsOneWidget);
    expect(find.text('Australian values'), findsOneWidget);
  });
}
