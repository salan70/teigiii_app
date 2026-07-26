import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// empty / error / loading の use case。
List<WidgetbookComponent> dsFeedbackComponents() => [
  WidgetbookComponent(
    name: 'DsEmptyView',
    useCases: [
      WidgetbookUseCase(
        name: '標準',
        builder: (context) => const DsEmptyView(message: 'まだ定義がありません。'),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => const DsEmptyView(
          message:
              'まだ定義がありません。'
              '気になる言葉を検索して、最初の定義を投稿してみてください。',
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'DsErrorView',
    useCases: [
      WidgetbookUseCase(
        name: 'standard',
        builder: (context) => DsErrorView.standard(onRetry: () {}),
      ),
      WidgetbookUseCase(
        name: 'standard / 副次操作あり',
        builder: (context) => DsErrorView.standard(
          onRetry: () {},
          secondaryActionText: '運営へお問い合わせ',
          onSecondaryAction: () {},
        ),
      ),
      WidgetbookUseCase(
        name: 'compact',
        builder: (context) => DsErrorView.compact(onRetry: () {}),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'DsShimmer',
    useCases: [
      WidgetbookUseCase(
        name: 'rectangular',
        builder: (context) => const Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: DsShimmer.rectangular(height: 24),
        ),
      ),
      WidgetbookUseCase(
        name: 'circular',
        builder: (context) => const DsShimmer.circular(
          width: DsSize.avatarIcon,
          height: DsSize.avatarIcon,
        ),
      ),
      WidgetbookUseCase(
        name: 'pill',
        builder: (context) => const DsShimmer.pill(width: 144, height: 40),
      ),
      WidgetbookUseCase(
        name: 'リストの読み込み中',
        builder: (context) => const Padding(
          padding: DsSpacing.screenHorizontalInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DsShimmer.rectangular(height: 24),
              SizedBox(height: DsSpacing.inline),
              DsShimmer.rectangular(height: 24, width: 200),
              SizedBox(height: DsSpacing.inline),
              DsShimmer.rectangular(height: 24, width: 120),
            ],
          ),
        ),
      ),
    ],
  ),
];
