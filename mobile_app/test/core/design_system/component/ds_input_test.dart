import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import '../ds_test_harness.dart';

void main() {
  group('DsSearchField', () {
    testWidgets('未入力ではクリアボタンを出さない', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpDsWidget(
        tester,
        DsSearchField(controller: controller, hintText: '言葉を検索'),
      );

      expect(find.bySemanticsLabel('入力を消去'), findsNothing);
      expect(find.text('言葉を検索'), findsOneWidget);
    });

    testWidgets('入力するとクリアボタンが出て、押すと空になる', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpDsWidget(
        tester,
        DsSearchField(controller: controller, hintText: '言葉を検索'),
      );

      await tester.enterText(find.byType(TextField), 'カレー');
      await tester.pump();
      expect(find.bySemanticsLabel('入力を消去'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('入力を消去'));
      await tester.pump();
      expect(controller.text, isEmpty);
    });

    testWidgets('高さ 48 と左右余白 40 を内部に持つ', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpDsWidget(
        tester,
        DsSearchField(controller: controller, hintText: '言葉を検索'),
      );

      final outerWidth = tester.getSize(find.byType(DsSearchField)).width;
      final fieldSize = tester.getSize(find.byType(TextField));

      expect(fieldSize.height, 48);
      expect(fieldSize.width, outerWidth - 40 * 2);
    });

    testWidgets('maxLength を付けても高さ 48 を保つ', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpDsWidget(
        tester,
        DsSearchField(
          controller: controller,
          hintText: '9桁のIDを入力',
          maxLength: 9,
        ),
      );

      expect(tester.getSize(find.byType(TextField)).height, 48);
      expect(find.text('0/9'), findsNothing);
    });

    testWidgets('確定すると onSubmitted が呼ばれる', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? submitted;

      await pumpDsWidget(
        tester,
        DsSearchField(
          controller: controller,
          hintText: '言葉を検索',
          onSubmitted: (value) => submitted = value,
        ),
      );

      await tester.enterText(find.byType(TextField), 'カレー');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      expect(submitted, 'カレー');
    });
  });

  group('DsTextField', () {
    testWidgets('ラベルと入力例を表示する', (tester) async {
      await pumpDsWidget(
        tester,
        const DsTextField.singleLine(label: '登録する言葉', hintText: '例: 二日目のカレー'),
      );

      expect(find.text('登録する言葉'), findsOneWidget);
      expect(find.text('例: 二日目のカレー'), findsOneWidget);
    });

    testWidgets('errorText を表示する', (tester) async {
      await pumpDsWidget(
        tester,
        const DsTextField.singleLine(label: '言葉', errorText: '入力してください'),
      );

      expect(find.text('入力してください'), findsOneWidget);
    });

    testWidgets('入力すると onChanged が呼ばれる', (tester) async {
      String? changed;
      await pumpDsWidget(
        tester,
        DsTextField.singleLine(
          label: '言葉',
          onChanged: (value) => changed = value,
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'カレー');
      expect(changed, 'カレー');
    });

    testWidgets('singleLine は 1 行、multiline は行数無制限', (tester) async {
      await pumpDsWidget(tester, const DsTextField.singleLine(label: 'a'));
      expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 1);

      await pumpDsWidget(tester, const DsTextField.multiline(label: 'a'));
      expect(tester.widget<TextField>(find.byType(TextField)).maxLines, isNull);
    });

    testWidgets('size で文字の大きさが変わる', (tester) async {
      await pumpDsWidget(
        tester,
        const DsTextField.singleLine(
          label: 'a',
          initialValue: 'x',
          size: DsTextFieldSize.prominent,
        ),
      );
      final prominent = tester.widget<TextField>(find.byType(TextField)).style!;

      await pumpDsWidget(
        tester,
        const DsTextField.singleLine(label: 'a', initialValue: 'x'),
      );
      final standard = tester.widget<TextField>(find.byType(TextField)).style!;

      expect(prominent, isNot(standard));
    });

    testWidgets('readOnly では編集できない', (tester) async {
      await pumpDsWidget(
        tester,
        const DsTextField.singleLine(label: 'a', readOnly: true),
      );

      expect(tester.widget<TextField>(find.byType(TextField)).readOnly, isTrue);
    });
  });

  group('DsIconButton', () {
    testWidgets('ラベルを持ち、タップで onPressed が呼ばれる', (tester) async {
      var tapped = 0;
      await pumpDsWidget(
        tester,
        DsIconButton(
          icon: Icons.more_horiz,
          semanticLabel: 'この定義の操作',
          onPressed: () => tapped++,
        ),
      );

      expect(find.byTooltip('この定義の操作'), findsOneWidget);
      await tester.tap(find.byType(IconButton));
      expect(tapped, 1);
    });

    testWidgets('onPressed が null なら disabled になる', (tester) async {
      await pumpDsWidget(
        tester,
        const DsIconButton(
          icon: Icons.more_horiz,
          semanticLabel: 'この定義の操作',
          onPressed: null,
        ),
      );

      expect(
        tester.widget<IconButton>(find.byType(IconButton)).onPressed,
        isNull,
      );
    });
  });

  group('DsListTile', () {
    testWidgets('ラベルを表示し、タップで onTap が呼ばれる', (tester) async {
      var tapped = 0;
      await pumpDsWidget(
        tester,
        DsListTile.label(label: 'ミュートの管理', onTap: () => tapped++),
      );

      expect(find.text('ミュートの管理'), findsOneWidget);
      await tester.tap(find.text('ミュートの管理'));
      expect(tapped, 1);
    });

    testWidgets('withLeadingIcon は先頭アイコンを表示する', (tester) async {
      await pumpDsWidget(
        tester,
        DsListTile.withLeadingIcon(
          label: '使い方',
          leadingIcon: Icons.help_outline,
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });
  });
}
