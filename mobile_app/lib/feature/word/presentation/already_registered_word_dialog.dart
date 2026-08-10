import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// すでに登録済みの言葉だったことを伝えるダイアログ。
///
/// 閉じる操作（`context.maybePop()`）というルーティングの知識を持つため、
/// デザインシステムではなく feature 側に置いている。
/// 見た目と操作の仕様は [DsDialog] が持つ。
class AlreadyRegisteredWordDialog extends StatelessWidget {
  const AlreadyRegisteredWordDialog({super.key, required this.onViewWord});

  /// 言葉ページへ移動する処理。
  ///
  /// ここで指定した処理の前に、`context.maybePop()` が実行される。
  final VoidCallback onViewWord;

  @override
  Widget build(BuildContext context) {
    return DsDialog(
      content: const Text('この言葉はすでに登録されています。', textAlign: TextAlign.center),
      actions: [
        DsOutlinedButton.tertiary(text: '閉じる', onPressed: context.maybePop),
        DsFilledButton.primary(
          text: '言葉を見る',
          onPressed: () async {
            await context.maybePop();
            onViewWord();
          },
        ),
      ],
    );
  }
}
