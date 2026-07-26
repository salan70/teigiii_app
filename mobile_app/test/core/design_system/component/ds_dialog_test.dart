import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import '../ds_test_harness.dart';

void main() {
  group('DsDialog', () {
    testWidgets('本文と操作を表示する', (tester) async {
      await pumpDsWidget(
        tester,
        DsDialog(
          content: const Text('本文'),
          actions: [TextButton(onPressed: () {}, child: const Text('OK'))],
        ),
      );

      expect(find.text('本文'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });
  });

  group('DsConfirmDialog', () {
    testWidgets('確定とキャンセルがそれぞれのコールバックを呼ぶ', (tester) async {
      var confirmed = 0;
      var cancelled = 0;

      await pumpDsWidget(
        tester,
        DsConfirmDialog(
          message: '削除しますか？',
          confirmButtonText: '削除する',
          onConfirm: () => confirmed++,
          onCancel: () => cancelled++,
        ),
      );

      expect(find.text('削除しますか？'), findsOneWidget);

      await tester.tap(find.text('削除する'));
      await tester.tap(find.text('キャンセル'));

      expect(confirmed, 1);
      expect(cancelled, 1);
    });

    testWidgets('確定ボタンだけ error 色になる', (tester) async {
      final theme = buildDsThemeData(Brightness.light);

      await pumpDsWidget(
        tester,
        DsConfirmDialog(
          message: 'm',
          confirmButtonText: '削除する',
          onConfirm: () {},
          onCancel: () {},
        ),
      );

      final confirmText = tester.widget<Text>(find.text('削除する'));
      final cancelText = tester.widget<Text>(find.text('キャンセル'));

      expect(confirmText.style?.color, theme.colorScheme.error);
      expect(cancelText.style?.color, isNot(theme.colorScheme.error));
    });
  });
}
