import 'package:flutter/material.dart';

import '../token/ds_radius.dart';
import '../token/ds_spacing.dart';
import '../token/ds_theme_context.dart';

/// ボタンの用途。
///
/// 任意の色を渡す代わりに、用途を選ぶ。
enum DsButtonTone {
  /// 画面の主たるアクション。
  primary,

  /// 補助的なアクション。
  tertiary,
}

/// 塗りつぶしのボタン。
///
/// [onPressed] に null を渡すと disabled になる。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット261
class DsFilledButton extends StatelessWidget {
  /// 画面の主たるアクション用。
  const DsFilledButton.primary({
    super.key,
    required this.onPressed,
    required this.text,
  }) : tone = DsButtonTone.primary;

  /// 補助的なアクション用。
  const DsFilledButton.tertiary({
    super.key,
    required this.onPressed,
    required this.text,
  }) : tone = DsButtonTone.tertiary;

  /// ボタンタップ時の処理。null で disabled。
  final VoidCallback? onPressed;

  /// ボタンに表示するテキスト。
  final String text;

  /// ボタンの用途。
  final DsButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;
    final (background, foreground) = switch (tone) {
      DsButtonTone.primary => (colorScheme.primary, colorScheme.onPrimary),
      DsButtonTone.tertiary => (colorScheme.tertiary, colorScheme.onTertiary),
    };

    return _DsButtonBase(
      onPressed: onPressed,
      text: text,
      textColor: foreground,
      backgroundColor: background,
    );
  }
}

/// 枠線のボタン。
///
/// [onPressed] に null を渡すと disabled になる。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット261
class DsOutlinedButton extends StatelessWidget {
  /// 画面の主たるアクション用。
  const DsOutlinedButton.primary({
    super.key,
    required this.onPressed,
    required this.text,
  }) : tone = DsButtonTone.primary;

  /// 補助的なアクション用。
  const DsOutlinedButton.tertiary({
    super.key,
    required this.onPressed,
    required this.text,
  }) : tone = DsButtonTone.tertiary;

  /// ボタンタップ時の処理。null で disabled。
  final VoidCallback? onPressed;

  /// ボタンに表示するテキスト。
  final String text;

  /// ボタンの用途。
  final DsButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;
    final foreground = switch (tone) {
      DsButtonTone.primary => colorScheme.primary,
      DsButtonTone.tertiary => colorScheme.tertiary,
    };

    return _DsButtonBase(
      onPressed: onPressed,
      text: text,
      textColor: foreground,
      borderColor: foreground,
    );
  }
}

/// ボタンの共通実装。
class _DsButtonBase extends StatelessWidget {
  const _DsButtonBase({
    required this.onPressed,
    required this.text,
    required this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  final VoidCallback? onPressed;
  final String text;
  final Color textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: DsRadius.pillBorder),
        backgroundColor: backgroundColor,
        side: borderColor == null ? null : BorderSide(color: borderColor!),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DsSpacing.screenContent,
        ),
        child: Text(
          text,
          style: context.dsTypography.itemTitle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
