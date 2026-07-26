import 'package:flutter/material.dart';

import '../token/ds_size.dart';

/// アイコンだけの操作。
///
/// スクリーンリーダー向けのラベルを必須にしている。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット-261
class DsIconButton extends StatelessWidget {
  const DsIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  /// 表示するアイコン。
  final IconData icon;

  /// 操作の意味。スクリーンリーダーが読み上げる。
  final String semanticLabel;

  /// タップ時の処理。null で disabled。
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: DsSize.iconLarge),
      tooltip: semanticLabel,
      onPressed: onPressed,
    );
  }
}
