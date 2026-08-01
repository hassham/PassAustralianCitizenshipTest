import 'package:flutter/material.dart';

class DialogActionButtons extends StatelessWidget {
  const DialogActionButtons({
    required this.secondaryLabel,
    required this.onSecondaryPressed,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    super.key,
  });

  final String secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: onSecondaryPressed,
          child: Text(secondaryLabel),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: FilledButton(
          onPressed: onPrimaryPressed,
          child: Text(primaryLabel),
        ),
      ),
    ],
  );
}
