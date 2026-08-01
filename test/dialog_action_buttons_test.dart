import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/shared/presentation/dialog_action_buttons.dart';

void main() {
  testWidgets('dialog actions remain compact and side by side', (tester) async {
    tester.view.physicalSize = const Size(350, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: AlertDialog(
          title: const Text('Start mock exam?'),
          content: const Text('Confirm the exam settings.'),
          actions: [
            DialogActionButtons(
              secondaryLabel: 'Cancel',
              onSecondaryPressed: () {},
              primaryLabel: 'Start exam',
              onPrimaryPressed: () {},
            ),
          ],
        ),
      ),
    );

    final outlinedButton = find.byType(OutlinedButton);
    final filledButton = find.byType(FilledButton);
    expect(tester.getSize(outlinedButton).width, lessThan(160));
    expect(tester.getSize(filledButton).width, lessThan(160));
    expect(
      tester.getCenter(outlinedButton).dy,
      closeTo(tester.getCenter(filledButton).dy, 1),
    );
    expect(tester.takeException(), isNull);
  });
}
