import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// 帯の use case。
List<WidgetbookComponent> dsChipComponents() => [
  WidgetbookComponent(
    name: 'DsChip',
    useCases: [
      WidgetbookUseCase(
        name: 'navigable',
        builder: (context) => Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: Align(
            alignment: Alignment.centerLeft,
            child: DsChip.navigable(label: 'この言葉は登録済みです', onTap: () {}),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: Align(
            alignment: Alignment.centerLeft,
            child: DsChip.navigable(
              label: 'この言葉はすでに登録済みです。同じよみで登録することはできません',
              onTap: () {},
            ),
          ),
        ),
      ),
    ],
  ),
];
