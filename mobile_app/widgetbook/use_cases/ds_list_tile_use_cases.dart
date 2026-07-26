import 'package:flutter/cupertino.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// リスト行の use case。
List<WidgetbookComponent> dsListTileComponent() => [
  WidgetbookComponent(
    name: 'DsListTile',
    useCases: [
      WidgetbookUseCase(
        name: 'label',
        builder: (context) => Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: DsListTile.label(label: 'あ', onTap: () {}),
        ),
      ),
      WidgetbookUseCase(
        name: 'withLeadingIcon',
        builder: (context) => Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: DsListTile.withLeadingIcon(
            label: 'ミュートの管理',
            leadingIcon: CupertinoIcons.speaker_slash,
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'disabled',
        builder: (context) => const Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: DsListTile.label(label: 'ミュートの管理', onTap: null),
        ),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: DsListTile.withLeadingIcon(
            label: 'とても長いラベルを持つ行で折り返しと省略の挙動を確認する',
            leadingIcon: CupertinoIcons.question_square,
            onTap: () {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: '連続した行',
        builder: (context) => Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DsListTile.withLeadingIcon(
                label: '使い方',
                leadingIcon: CupertinoIcons.question_square,
                onTap: () {},
              ),
              DsListTile.withLeadingIcon(
                label: 'お問い合わせ',
                leadingIcon: CupertinoIcons.mail,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];
