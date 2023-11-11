import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// 入力系の画面を閉じる際に確認ダイアログを表示する
Future<void> showCloseConfirmDialog(BuildContext context) async {
  await showDialog<dynamic>(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 0,
        contentPadding: const EdgeInsets.only(
          top: 40,
          bottom: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('入力した内容は保存されません。'),
            Text('よろしいですか？'),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.only(bottom: 16),
        actions: [
          InkWell(
            onTap: () {
              context.popRoute();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'キャンセル',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
