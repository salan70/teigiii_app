import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'base_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.confirmMessage,
    required this.onConfirm,
    required this.confirmButtonText,
    this.willPopOnConfirm = true,
  });

  /// 本文として表示するメッセージ。
  final String confirmMessage;

  /// [confirmMessage] をタップした際の処理。
  ///
  /// [willPopOnConfirm] が `true` の場合、
  /// ここで指定した処理の前に、`context.popRoute()` が実行される。
  final VoidCallback onConfirm;

  /// [onConfirm] が実行される前に、`context.popRoute()` を実行するかどうか。
  final bool willPopOnConfirm;

  /// 了承する旨のボタンのテキスト。
  final String confirmButtonText;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      content: Text(confirmMessage, textAlign: TextAlign.center),
      actions: [
        InkWell(
          onTap: context.popRoute,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'キャンセル',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            if (willPopOnConfirm) {
              await context.popRoute();
            }

            onConfirm();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              confirmButtonText,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
