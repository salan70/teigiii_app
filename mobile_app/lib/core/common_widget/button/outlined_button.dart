import 'package:flutter/material.dart';

import '../../design_system/component/ds_button.dart';

/// primary カラーの枠線ボタン。
@Deprecated('DsOutlinedButton.primary を使う。全参照の移行後に削除する (#278)')
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
    return DsOutlinedButton.primary(onPressed: onPressed, text: text);
  }
}

/// tertiary カラーの枠線ボタン。
@Deprecated('DsOutlinedButton.tertiary を使う。全参照の移行後に削除する (#278)')
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
    return DsOutlinedButton.tertiary(onPressed: onPressed, text: text);
  }
}
