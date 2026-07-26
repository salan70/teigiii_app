import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import '../ds_test_harness.dart';

void main() {
  group('DsEmptyView', () {
    testWidgets('メッセージを表示する', (tester) async {
      await pumpDsWidget(tester, const DsEmptyView(message: 'まだありません'));
      expect(find.text('まだありません'), findsOneWidget);
    });
  });

  group('DsErrorView', () {
    testWidgets('standard は再読み込みで onRetry を呼ぶ', (tester) async {
      var retried = 0;
      await pumpDsWidget(
        tester,
        DsErrorView.standard(onRetry: () => retried++),
      );

      expect(find.text('エラーが発生しました。'), findsOneWidget);
      await tester.tap(find.text('再読み込み'));
      expect(retried, 1);
    });

    testWidgets('standard は副次操作を渡さなければ表示しない', (tester) async {
      await pumpDsWidget(tester, DsErrorView.standard(onRetry: () {}));
      expect(find.text('運営へお問い合わせ'), findsNothing);
    });

    testWidgets('standard は副次操作を渡すと表示してコールバックを呼ぶ', (tester) async {
      var tapped = 0;
      await pumpDsWidget(
        tester,
        DsErrorView.standard(
          onRetry: () {},
          secondaryActionText: '運営へお問い合わせ',
          onSecondaryAction: () => tapped++,
        ),
      );

      await tester.tap(find.text('運営へお問い合わせ'));
      expect(tapped, 1);
    });

    testWidgets('compact はタップで onRetry を呼ぶ', (tester) async {
      var retried = 0;
      await pumpDsWidget(tester, DsErrorView.compact(onRetry: () => retried++));

      expect(find.text('タップで再読み込み'), findsOneWidget);
      await tester.tap(find.text('タップで再読み込み'));
      expect(retried, 1);
    });
  });

  group('DsShimmer', () {
    testWidgets('variant ごとに形が変わる', (tester) async {
      for (final entry in <String, DsShimmer>{
        'rectangular': const DsShimmer.rectangular(width: 100, height: 20),
        'circular': const DsShimmer.circular(width: 40, height: 40),
        'pill': const DsShimmer.pill(width: 144, height: 40),
      }.entries) {
        await pumpDsWidget(tester, entry.value);
        expect(tester.takeException(), isNull, reason: entry.key);
      }
    });

    testWidgets('pill は pill の角丸を使う', (tester) async {
      const shimmer = DsShimmer.pill(width: 144, height: 40);
      expect(
        shimmer.shapeBorder,
        const RoundedRectangleBorder(borderRadius: DsRadius.pillBorder),
      );
    });
  });
}
