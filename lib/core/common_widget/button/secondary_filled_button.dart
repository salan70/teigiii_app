import 'package:flutter/material.dart';

/// 白黒を基調とした塗りつぶしボタン
class SecondaryFilledButton extends StatelessWidget {
  const SecondaryFilledButton({
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
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
        ),
      ),
    );
  }
}
