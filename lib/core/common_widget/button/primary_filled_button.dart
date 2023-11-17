import 'package:flutter/material.dart';

/// primaryカラーで塗りつぶされたボタン
class PrimaryFilledButton extends StatelessWidget {
  const PrimaryFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}
