import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// ダイアログの use case。
List<WidgetbookComponent> dsDialogComponents() => [
  WidgetbookComponent(
    name: 'DsDialog',
    useCases: [
      WidgetbookUseCase(
        name: '本文と 1 操作',
        builder: (context) => DsDialog(
          content: const Text('保存しました。'),
          actions: [TextButton(onPressed: () {}, child: const Text('閉じる'))],
        ),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => DsDialog(
          content: const Text(
            'この操作は取り消せません。'
            '削除したデータは復元できず、フォロワーからも見えなくなります。'
            '本当に実行してよいか確認してください。',
            textAlign: TextAlign.center,
          ),
          actions: [TextButton(onPressed: () {}, child: const Text('閉じる'))],
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'DsConfirmDialog',
    useCases: [
      WidgetbookUseCase(
        name: '標準',
        builder: (context) => DsConfirmDialog(
          message: 'この定義を削除しますか？',
          confirmButtonText: '削除する',
          onConfirm: () {},
          onCancel: () {},
        ),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => DsConfirmDialog(
          message:
              'この定義を削除しますか？\n削除すると復元できません。'
              'いいねやコメントも一緒に見えなくなります。',
          confirmButtonText: 'すべて削除する',
          onConfirm: () {},
          onCancel: () {},
        ),
      ),
    ],
  ),
];
