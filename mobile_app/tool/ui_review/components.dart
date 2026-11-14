import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import 'scenario.dart';

void _noop() {}

Scenario _scenario(Widget widget, {double? height}) =>
    Scenario(widget: widget, height: height);

/// Ds コンポーネントの状態。キーは `targets.json` の対象 ID と状態 ID。
///
/// 非公開クラス（`_DsButtonBase` など）は、包む公開クラスの撮影で描かれる。
final Map<String, Map<String, ScenarioBuilder>> componentScenarios = {
  'component.ds_filled_button': {
    'primary': () => _scenario(
      const DsFilledButton.primary(onPressed: _noop, text: '再読み込み'),
    ),
    'primary-disabled': () =>
        _scenario(const DsFilledButton.primary(onPressed: null, text: '再読み込み')),
    'tertiary': () => _scenario(
      const DsFilledButton.tertiary(onPressed: _noop, text: '運営へお問い合わせ'),
    ),
    'tertiary-disabled': () => _scenario(
      const DsFilledButton.tertiary(onPressed: null, text: '運営へお問い合わせ'),
    ),
  },
  'component.ds_outlined_button': {
    'primary': () => _scenario(
      const DsOutlinedButton.primary(onPressed: _noop, text: '再読み込み'),
    ),
    'primary-disabled': () => _scenario(
      const DsOutlinedButton.primary(onPressed: null, text: '再読み込み'),
    ),
    'tertiary': () => _scenario(
      const DsOutlinedButton.tertiary(onPressed: _noop, text: '運営へお問い合わせ'),
    ),
    'tertiary-disabled': () => _scenario(
      const DsOutlinedButton.tertiary(onPressed: null, text: '運営へお問い合わせ'),
    ),
  },
  'component.ds_icon_button': {
    'enabled': () => _scenario(
      const DsIconButton(
        icon: Icons.more_horiz,
        semanticLabel: 'この定義の操作',
        onPressed: _noop,
      ),
    ),
    'disabled': () => _scenario(
      const DsIconButton(
        icon: Icons.more_horiz,
        semanticLabel: 'この定義の操作',
        onPressed: null,
      ),
    ),
  },
  'component.ds_list_tile': {
    'with-leading-icon': () => _scenario(
      const DsListTile.withLeadingIcon(
        label: 'ミュートの管理',
        leadingIcon: Icons.volume_off,
        onTap: _noop,
      ),
    ),
    'label-only': () =>
        _scenario(const DsListTile.label(label: 'ライセンス', onTap: _noop)),
    'disabled': () => _scenario(
      const DsListTile.withLeadingIcon(
        label: 'ミュートの管理',
        leadingIcon: Icons.volume_off,
        onTap: null,
      ),
    ),
  },
  'component.ds_chip': {
    'navigable': () =>
        _scenario(const DsChip.navigable(label: 'この言葉は登録済みです', onTap: _noop)),
    'long-label': () => _scenario(
      const DsChip.navigable(
        label: 'この言葉はすでに登録されています。タップして既存の言葉を開く',
        onTap: _noop,
      ),
    ),
  },
  'component.ds_dialog': {
    'default': () => _scenario(
      const DsDialog(
        content: Text('この操作の内容を説明する本文'),
        actions: [DsOutlinedButton.tertiary(onPressed: _noop, text: '閉じる')],
      ),
      height: 400,
    ),
  },
  'component.ds_confirm_dialog': {
    'default': () => _scenario(
      const DsConfirmDialog(
        message: 'この定義を削除しますか？',
        confirmButtonText: '削除する',
        onConfirm: _noop,
        onCancel: _noop,
      ),
      height: 400,
    ),
  },
  'component.ds_app_bar_action': {
    'enabled': () =>
        _scenario(const DsAppBarAction(label: '登録', onPressed: _noop)),
    'disabled': () =>
        _scenario(const DsAppBarAction(label: '登録', onPressed: null)),
  },
  'component.ds_search_field': {
    'empty': () => _scenario(
      DsSearchField(controller: TextEditingController(), hintText: '言葉を検索'),
    ),
    'filled': () => _scenario(
      DsSearchField(
        controller: TextEditingController(text: '二日目のカレー'),
        hintText: '言葉を検索',
      ),
    ),
  },
  'component.ds_text_field': {
    'single-line': () => _scenario(
      const DsTextField.singleLine(label: '登録する言葉', initialValue: '二日目のカレー'),
    ),
    'single-line-error': () => _scenario(
      const DsTextField.singleLine(
        label: '登録する言葉',
        initialValue: '二日目のカレー',
        errorText: 'この言葉はすでに登録されています',
      ),
    ),
    'single-line-hint': () => _scenario(
      const DsTextField.singleLine(label: '登録する言葉', hintText: '例: 二日目のカレー'),
    ),
    'multiline': () => _scenario(
      const DsTextField.multiline(
        label: '定義',
        initialValue: '作ってから一晩経ったカレー。ばり美味い',
        maxLength: 200,
      ),
      height: 320,
    ),
    'read-only': () => _scenario(
      const DsTextField.singleLine(
        label: '登録する言葉',
        initialValue: '二日目のカレー',
        readOnly: true,
      ),
    ),
  },
  'component.ds_empty_view': {
    'default': () => _scenario(const DsEmptyView(message: 'まだ定義がありません。')),
  },
  'component.ds_error_view': {
    'standard': () =>
        _scenario(const DsErrorView.standard(onRetry: _noop), height: 360),
    'standard-with-secondary': () => _scenario(
      const DsErrorView.standard(
        onRetry: _noop,
        secondaryActionText: '運営へお問い合わせ',
        onSecondaryAction: _noop,
      ),
      height: 400,
    ),
    'compact': () => _scenario(const DsErrorView.compact(onRetry: _noop)),
  },
  'component.ds_shimmer': {
    'rectangular': () => _scenario(
      const Padding(
        padding: EdgeInsets.all(16),
        child: DsShimmer.rectangular(height: 80),
      ),
    ),
    'circular': () =>
        _scenario(const DsShimmer.circular(width: 64, height: 64)),
  },
};
