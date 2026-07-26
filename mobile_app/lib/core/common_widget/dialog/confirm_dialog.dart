import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../design_system/component/ds_dialog.dart';

/// 確認ダイアログ。
///
/// 閉じる操作（`context.popRoute()`）というルーティングの知識を持つため、
/// デザインシステムではなく feature 側に置いている。
/// 見た目と操作の仕様は [DsConfirmDialog] が持つ。
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.confirmMessage,
    required this.onAccept,
    required this.confirmButtonText,
  });

  /// 本文として表示するメッセージ。
  final String confirmMessage;

  /// 了承した際の処理。
  ///
  /// ここで指定した処理の前に、`context.popRoute()` が実行される。
  final VoidCallback onAccept;

  /// 了承する旨のボタンのテキスト。
  final String confirmButtonText;

  @override
  Widget build(BuildContext context) {
    return DsConfirmDialog(
      message: confirmMessage,
      confirmButtonText: confirmButtonText,
      onCancel: context.popRoute,
      onConfirm: () async {
        await context.popRoute();
        onAccept();
      },
    );
  }
}
