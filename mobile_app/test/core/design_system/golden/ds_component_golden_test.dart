@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import 'ds_golden_harness.dart';

/// Ds コンポーネントの golden。
///
/// **ローカル限定。CI では実行しない**（`just mobile-test` は
/// `--exclude-tags golden`）。開発機と CI でラスタライズ結果が一致しないため。
/// 撮り直しは `just mobile-test-golden-update`。
void main() {
  setUpAll(loadDsFonts);

  // DsShimmer は無限アニメーションのため golden の対象外にしている
  // （`pumpAndSettle` が収束せず、撮るたびに位相が変わる）。
  final cases = <String, Widget>{
    'ds_filled_button_primary': DsFilledButton.primary(
      onPressed: () {},
      text: '再読み込み',
    ),
    'ds_filled_button_disabled': const DsFilledButton.primary(
      onPressed: null,
      text: '再読み込み',
    ),
    'ds_outlined_button_tertiary': DsOutlinedButton.tertiary(
      onPressed: () {},
      text: '運営へお問い合わせ',
    ),
    'ds_outlined_button_disabled': const DsOutlinedButton.tertiary(
      onPressed: null,
      text: '運営へお問い合わせ',
    ),
    'ds_icon_button': DsIconButton(
      icon: Icons.more_horiz,
      semanticLabel: 'この定義の操作',
      onPressed: () {},
    ),
    'ds_list_tile': DsListTile.withLeadingIcon(
      label: 'ミュートの管理',
      leadingIcon: Icons.volume_off,
      onTap: () {},
    ),
    'ds_app_bar_action': DsAppBarAction(label: '登録', onPressed: () {}),
    'ds_app_bar_action_disabled': const DsAppBarAction(
      label: '登録',
      onPressed: null,
    ),
    'ds_chip_navigable': DsChip.navigable(
      label: 'この言葉は登録済みです',
      onTap: () {},
    ),
    'ds_empty_view': const DsEmptyView(message: 'まだ定義がありません。'),
    'ds_error_view_compact': DsErrorView.compact(onRetry: () {}),
    'ds_text_field': const DsTextField.singleLine(
      label: '登録する言葉',
      initialValue: '二日目のカレー',
    ),
  };

  for (final brightness in Brightness.values) {
    final suffix = brightness == Brightness.light ? 'light' : 'dark';
    for (final entry in cases.entries) {
      testWidgets('${entry.key} ($suffix)', (tester) async {
        await pumpDsGolden(tester, entry.value, brightness: brightness);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${entry.key}_$suffix.png'),
        );
      });
    }
  }

  testWidgets('ds_error_view_standard (light)', (tester) async {
    await pumpDsGolden(
      tester,
      DsErrorView.standard(
        onRetry: () {},
        secondaryActionText: '運営へお問い合わせ',
        onSecondaryAction: () {},
      ),
      size: const Size(390, 400),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/ds_error_view_standard_light.png'),
    );
  });

  testWidgets('ds_confirm_dialog (light)', (tester) async {
    await pumpDsGolden(
      tester,
      DsConfirmDialog(
        message: 'この定義を削除しますか？',
        confirmButtonText: '削除する',
        onConfirm: () {},
        onCancel: () {},
      ),
      size: const Size(390, 400),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/ds_confirm_dialog_light.png'),
    );
  });
}
