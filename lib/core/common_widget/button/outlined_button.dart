import 'package:flutter/material.dart';

/// アプリ内で使用する Outlined ボタンの基底クラス。
class _BaseOutlinedButton extends StatelessWidget {
  const _BaseOutlinedButton({
    required this.onPressed,
    required this.text,
    required this.textColor,
    required this.borderColor,
  });

  /// ボタンタップ時の処理。
  final VoidCallback? onPressed;

  /// ボタンに表示するテキスト。
  final String text;

  /// [text] の色。
  final Color textColor;

  /// ボタンの枠線の色。
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        side: BorderSide(
          color: borderColor,
        ),
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
class PrimaryOutlinedButton extends StatelessWidget {
  const PrimaryOutlinedButton({
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
    return _BaseOutlinedButton(
      onPressed: onPressed,
      text: text,
      textColor: Theme.of(context).colorScheme.primary,
      borderColor: Theme.of(context).colorScheme.primary,
    );
  }
}

/// tertiary カラーで塗りつぶされたボタン。
class TertiaryOutlinedButton extends StatelessWidget {
  const TertiaryOutlinedButton({
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
    return _BaseOutlinedButton(
      onPressed: onPressed,
      text: text,
      textColor: Theme.of(context).colorScheme.tertiary,
      borderColor: Theme.of(context).colorScheme.tertiary,
    );
  }
}
