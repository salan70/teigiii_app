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

    testWidgets('disabled は enabled と見た目が異なる', (tester) async {
      await pumpDsWidget(
        tester,
        DsFilledButton.primary(onPressed: () {}, text: '保存'),
      );
      final enabledText = tester.widget<Text>(find.text('保存')).style?.color;
      final enabledBackground = tester
          .widget<TextButton>(find.byType(TextButton))
          .style
          ?.backgroundColor
          ?.resolve(<WidgetState>{});

      await pumpDsWidget(
        tester,
        const DsFilledButton.primary(onPressed: null, text: '保存'),
      );
      final disabledText = tester.widget<Text>(find.text('保存')).style?.color;
      final disabledBackground = tester
          .widget<TextButton>(find.byType(TextButton))
          .style
          ?.backgroundColor
          ?.resolve(<WidgetState>{WidgetState.disabled});

      expect(disabledText, isNot(enabledText));
      expect(disabledBackground, isNot(enabledBackground));
      expect(disabledText?.opacity, closeTo(DsOpacity.disabled, 0.01));
    });

    testWidgets('primary と tertiary で背景色が変わる', (tester) async {
      final theme = buildDsThemeData(Brightness.light);

      await pumpDsWidget(
        tester,
        DsFilledButton.primary(onPressed: () {}, text: 'a'),
      );
      final primaryText = tester.widget<Text>(find.text('a'));

      await pumpDsWidget(
        tester,
        DsFilledButton.tertiary(onPressed: () {}, text: 'a'),
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

    testWidgets('disabled は枠線と文字が薄くなる', (tester) async {
      await pumpDsWidget(
        tester,
        DsOutlinedButton.primary(onPressed: () {}, text: 'キャンセル'),
      );
      final enabledText = tester.widget<Text>(find.text('キャンセル')).style?.color;

      await pumpDsWidget(
        tester,
        const DsOutlinedButton.primary(onPressed: null, text: 'キャンセル'),
      );
      final disabledText = tester.widget<Text>(find.text('キャンセル')).style?.color;
      final side = tester
          .widget<TextButton>(find.byType(TextButton))
          .style
          ?.side
          ?.resolve(<WidgetState>{WidgetState.disabled});

      expect(disabledText, isNot(enabledText));
      expect(disabledText?.opacity, closeTo(DsOpacity.disabled, 0.01));
      expect(side?.color.opacity, closeTo(DsOpacity.disabled, 0.01));
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

  group('DsAppBarAction', () {
    testWidgets('ラベルを表示し、タップで onPressed が呼ばれる', (tester) async {
      var tappedCount = 0;

      await pumpDsWidget(
        tester,
        DsAppBarAction(label: '登録', onPressed: () => tappedCount++),
      );
      await tester.tap(find.text('登録'));

      expect(tappedCount, 1);
    });

    testWidgets('onPressed が null なら操作できず薄く表示する', (tester) async {
      await pumpDsWidget(
        tester,
        const DsAppBarAction(label: '登録', onPressed: null),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.onTap, isNull);

      final text = tester.widget<Text>(find.text('登録'));
      expect(text.style?.color?.opacity, closeTo(DsOpacity.disabled, 0.01));
    });
  });
}
