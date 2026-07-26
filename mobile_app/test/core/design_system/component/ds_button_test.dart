import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import '../ds_test_harness.dart';

void main() {
  group('DsFilledButton', () {
    testWidgets('テキストを表示し、タップで onPressed が呼ばれる', (tester) async {
      var tapped = 0;
      await pumpDsWidget(
        tester,
        DsFilledButton.primary(onPressed: () => tapped++, text: '保存'),
      );

      expect(find.text('保存'), findsOneWidget);
      await tester.tap(find.text('保存'));
      expect(tapped, 1);
    });

    testWidgets('onPressed が null なら disabled になる', (tester) async {
      await pumpDsWidget(
        tester,
        const DsFilledButton.primary(onPressed: null, text: '保存'),
      );

      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.enabled, isFalse);
    });

    testWidgets('primary と tertiary で背景色が変わる', (tester) async {
      final theme = buildDsThemeData(Brightness.light);

      await pumpDsWidget(
        tester,
        const DsFilledButton.primary(onPressed: null, text: 'a'),
      );
      final primaryText = tester.widget<Text>(find.text('a'));

      await pumpDsWidget(
        tester,
        const DsFilledButton.tertiary(onPressed: null, text: 'a'),
      );
      final tertiaryText = tester.widget<Text>(find.text('a'));

      expect(primaryText.style?.color, theme.colorScheme.onPrimary);
      expect(tertiaryText.style?.color, theme.colorScheme.onTertiary);
    });

    testWidgets('長文でも例外なく描画できる', (tester) async {
      await pumpDsWidget(
        tester,
        DsFilledButton.primary(onPressed: () {}, text: 'とても長いラベル' * 10),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('DsOutlinedButton', () {
    testWidgets('テキストを表示し、タップで onPressed が呼ばれる', (tester) async {
      var tapped = 0;
      await pumpDsWidget(
        tester,
        DsOutlinedButton.tertiary(onPressed: () => tapped++, text: '閉じる'),
      );

      await tester.tap(find.text('閉じる'));
      expect(tapped, 1);
    });

    testWidgets('背景色を持たない', (tester) async {
      await pumpDsWidget(
        tester,
        DsOutlinedButton.primary(onPressed: () {}, text: '閉じる'),
      );

      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.style?.backgroundColor?.resolve(<WidgetState>{}), isNull);
    });
  });
}
