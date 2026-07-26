import 'package:flutter/material.dart';

import '../../design_system/component/ds_button.dart';

/// primary カラーで塗りつぶされたボタン。
@Deprecated('DsFilledButton.primary を使う。全参照の移行後に削除する (#278)')
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
    return DsFilledButton.primary(onPressed: onPressed, text: text);
  }
}

/// tertiary カラーで塗りつぶされたボタン。
@Deprecated('DsFilledButton.tertiary を使う。全参照の移行後に削除する (#278)')
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
    return DsFilledButton.tertiary(onPressed: onPressed, text: text);
  }
}
