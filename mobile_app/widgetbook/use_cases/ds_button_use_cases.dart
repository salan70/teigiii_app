import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// ボタンの use case。
List<WidgetbookComponent> dsButtonComponents() => [
  WidgetbookComponent(
    name: 'DsFilledButton',
    useCases: [
      WidgetbookUseCase(
        name: 'primary',
        builder: (context) =>
            DsFilledButton.primary(onPressed: () {}, text: '再読み込み'),
      ),
      WidgetbookUseCase(
        name: 'tertiary',
        builder: (context) =>
            DsFilledButton.tertiary(onPressed: () {}, text: 'フォローする'),
      ),
      WidgetbookUseCase(
        name: 'disabled',
        builder: (context) =>
            const DsFilledButton.primary(onPressed: null, text: '保存する'),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => DsFilledButton.primary(
          onPressed: () {},
          text: 'とても長いラベルを持つボタンで折り返しの挙動を確認する',
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'DsOutlinedButton',
    useCases: [
      WidgetbookUseCase(
        name: 'primary',
        builder: (context) =>
            DsOutlinedButton.primary(onPressed: () {}, text: 'キャンセル'),
      ),
      WidgetbookUseCase(
        name: 'tertiary',
        builder: (context) =>
            DsOutlinedButton.tertiary(onPressed: () {}, text: '運営へお問い合わせ'),
      ),
      WidgetbookUseCase(
        name: 'disabled',
        builder: (context) =>
            const DsOutlinedButton.primary(onPressed: null, text: 'キャンセル'),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => DsOutlinedButton.tertiary(
          onPressed: () {},
          text: 'とても長いラベルを持つボタンで折り返しの挙動を確認する',
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'DsIconButton',
    useCases: [
      WidgetbookUseCase(
        name: 'enabled',
        builder: (context) => DsIconButton(
          icon: Icons.more_horiz,
          semanticLabel: 'この定義の操作',
          onPressed: () {},
        ),
      ),
      WidgetbookUseCase(
        name: 'disabled',
        builder: (context) => const DsIconButton(
          icon: Icons.more_horiz,
          semanticLabel: 'この定義の操作',
          onPressed: null,
        ),
      ),
    ],
  ),
];
