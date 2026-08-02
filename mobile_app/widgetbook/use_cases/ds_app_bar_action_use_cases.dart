import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// AppBar のテキスト操作の use case。
List<WidgetbookComponent> dsAppBarActionComponents() => [
  WidgetbookComponent(
    name: 'DsAppBarAction',
    useCases: [
      WidgetbookUseCase(
        name: 'enabled',
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('言葉を登録'),
            actions: [DsAppBarAction(label: '登録', onPressed: () {})],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'disabled',
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('言葉を登録'),
            actions: const [DsAppBarAction(label: '登録', onPressed: null)],
          ),
        ),
      ),
    ],
  ),
];
