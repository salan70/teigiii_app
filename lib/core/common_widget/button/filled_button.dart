import 'package:flutter/material.dart';

/// アプリ内で使用する Filled ボタンの基底クラス。
class _BaseFilledButton extends StatelessWidget {
  const _BaseFilledButton({
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  /// ボタンタップ時の処理。
  final VoidCallback? onPressed;

  /// ボタンに表示するテキスト。
  final String text;

  /// ボタンの背景色。
  final Color backgroundColor;

  /// [text] の色。
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
        ),
      ),
    );
  }
}

/// primary カラーで塗りつぶされたボタン。
class PrimaryFilledButton extends StatelessWidget {
  const PrimaryFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  /// ボタンタップ時の処理。
  final VoidCallback? onPressed;

  /// ボタンに表示するテキスト。
  final String text;

  @override
  Widget build(BuildContext context) {
    return _BaseFilledButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}

/// tertiary カラーで塗りつぶされたボタン。
class TertiaryFilledButton extends StatelessWidget {
  const TertiaryFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  /// ボタンタップ時の処理。
  final VoidCallback? onPressed;

  /// ボタンに表示するテキスト。
  final String text;

  @override
  Widget build(BuildContext context) {
    return _BaseFilledButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      textColor: Theme.of(context).colorScheme.onTertiary,
    );
  }
}
