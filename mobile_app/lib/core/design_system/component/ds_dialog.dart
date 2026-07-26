import 'package:flutter/material.dart';

import '../token/ds_elevation.dart';
import '../token/ds_radius.dart';
import '../token/ds_spacing.dart';
import '../token/ds_theme_context.dart';

/// ダイアログの外枠。
///
/// 中身と操作は [content] / [actions] で渡す。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット-261
class DsDialog extends StatelessWidget {
  const DsDialog({super.key, required this.content, required this.actions});

  /// 本文。
  final Widget content;

  /// 下部に並べる操作。
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: DsElevation.none,
      contentPadding: const EdgeInsets.only(
        top: DsSpacing.screenEnd,
        bottom: DsSpacing.containerContent,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: DsRadius.containerBorder,
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [content]),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.only(bottom: DsSpacing.containerContent),
      actions: actions,
    );
  }
}

/// 確認ダイアログ。
///
/// キャンセルと確定の 2 択だけを持つ。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット-261
class DsConfirmDialog extends StatelessWidget {
  const DsConfirmDialog({
    super.key,
    required this.message,
    required this.confirmButtonText,
    required this.onConfirm,
    required this.onCancel,
  });

  /// 本文として表示するメッセージ。
  final String message;

  /// 確定ボタンのテキスト。
  final String confirmButtonText;

  /// 確定時の処理。
  final VoidCallback onConfirm;

  /// キャンセル時の処理。
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return DsDialog(
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        _DsDialogAction(label: 'キャンセル', onTap: onCancel),
        _DsDialogAction(
          label: confirmButtonText,
          onTap: onConfirm,
          isDestructive: true,
        ),
      ],
    );
  }
}

/// ダイアログ内の操作 1 つ。
class _DsDialogAction extends StatelessWidget {
  const _DsDialogAction({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final style = context.dsTypography.itemTitle;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: DsSpacing.containerContentInsets,
        child: Text(
          label,
          style: isDestructive
              ? style.copyWith(color: context.dsColorScheme.error)
              : style,
        ),
      ),
    );
  }
}
