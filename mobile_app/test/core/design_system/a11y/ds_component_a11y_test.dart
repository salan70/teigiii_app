import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import '../ds_test_harness.dart';

/// Ds コンポーネントに対する Flutter Accessibility Guideline の検査。
///
/// 対象は Ds コンポーネントに限定する。既存画面への一括適用は
/// `doc/specs/mobile-app-design-system.md` の「golden test の位置づけ」を参照。
void main() {
  /// 操作可能なコンポーネント。tap target とラベルの検査対象。
  Map<String, Widget> tappableComponents() => {
    'DsFilledButton.primary': DsFilledButton.primary(
      onPressed: () {},
      text: '再読み込み',
    ),
    'DsOutlinedButton.tertiary': DsOutlinedButton.tertiary(
      onPressed: () {},
      text: '運営へお問い合わせ',
    ),
    'DsIconButton': DsIconButton(
      icon: Icons.more_horiz,
      semanticLabel: 'この定義の操作',
      onPressed: () {},
    ),
    'DsListTile': DsListTile.withLeadingIcon(
      label: 'ミュートの管理',
      leadingIcon: Icons.volume_off,
      onTap: () {},
    ),
  };

  /// テキストを持つコンポーネント。コントラストの検査対象。
  ///
  /// 塗りつぶしボタンは対象外。primary `#0BBBA1` と白文字のコントラスト比が
  /// 2.43 で基準（3.0）を下回るが、これは移行前から同じ配色であり、
  /// 直すと見た目が変わる。判断は #279 で行う。
  /// `DsErrorView.standard` は内部で塗りつぶしボタンを使うため同様に対象外。
  Map<String, Widget> textComponents() => {
    'DsOutlinedButton.tertiary': DsOutlinedButton.tertiary(
      onPressed: () {},
      text: '運営へお問い合わせ',
    ),
    'DsIconButton': DsIconButton(
      icon: Icons.more_horiz,
      semanticLabel: 'この定義の操作',
      onPressed: () {},
    ),
    'DsListTile': DsListTile.withLeadingIcon(
      label: 'ミュートの管理',
      leadingIcon: Icons.volume_off,
      onTap: () {},
    ),
    'DsEmptyView': const DsEmptyView(message: 'まだ定義がありません'),
    'DsErrorView.compact': DsErrorView.compact(onRetry: () {}),
    'DsTextField': const DsTextField.singleLine(
      label: '登録する言葉',
      initialValue: '二日目のカレー',
    ),
  };

  group('tap target', () {
    for (final entry in tappableComponents().entries) {
      testWidgets('${entry.key} が Android の最小タップ領域を満たす', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpDsWidget(tester, entry.value);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      });

      testWidgets('${entry.key} が iOS の最小タップ領域を満たす', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpDsWidget(tester, entry.value);
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        handle.dispose();
      });

      testWidgets('${entry.key} がラベルを持つ', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpDsWidget(tester, entry.value);
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });
    }
  });

  group('text contrast', () {
    for (final brightness in Brightness.values) {
      for (final entry in textComponents().entries) {
        testWidgets('$brightness の ${entry.key} が文字コントラストを満たす', (tester) async {
          final handle = tester.ensureSemantics();
          await pumpDsWidget(tester, entry.value, brightness: brightness);
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          handle.dispose();
        });
      }
    }
  });
}
