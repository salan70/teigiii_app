import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../token/ds_radius.dart';
import '../token/ds_size.dart';
import '../token/ds_spacing.dart';
import '../token/ds_theme_context.dart';
import 'ds_button.dart';

/// 空状態の表示。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット261
class DsEmptyView extends StatelessWidget {
  const DsEmptyView({super.key, required this.message});

  /// 空であることを説明するメッセージ。
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(DsSpacing.screenEnd),
        Center(
          child: Text(
            message,
            style: context.dsTypography.itemTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// エラー状態の表示。
///
/// 問い合わせ導線のようなドメイン知識は持たず、渡された操作を並べるだけ。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット261
class DsErrorView extends StatelessWidget {
  /// 本文つきのエラー表示。
  ///
  /// [onSecondaryAction] を渡すと副次的な操作を追加する。
  const DsErrorView.standard({
    super.key,
    required this.onRetry,
    this.onSecondaryAction,
    this.secondaryActionText,
  }) : isCompact = false;

  /// リスト内など、狭い場所で使う簡易表示。
  const DsErrorView.compact({super.key, required this.onRetry})
    : isCompact = true,
      onSecondaryAction = null,
      secondaryActionText = null;

  /// リトライ時の処理。
  final VoidCallback onRetry;

  /// 副次的な操作。null なら表示しない。
  final VoidCallback? onSecondaryAction;

  /// 副次的な操作のラベル。
  final String? secondaryActionText;

  /// 簡易表示かどうか。
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _DsCompactErrorView(onRetry: onRetry);
    }

    final colorScheme = context.dsColorScheme;
    final typography = context.dsTypography;

    return Column(
      children: [
        Icon(
          CupertinoIcons.exclamationmark_circle_fill,
          color: colorScheme.error,
          size: DsSize.iconLarge,
        ),
        const Gap(DsSpacing.inline),
        Text('エラーが発生しました。', style: typography.heading),
        const Gap(DsSpacing.inline),
        Text('再読み込みをお試しください。', style: typography.body),
        Text('繰り返し発生する場合は、運営へお問い合わせください。', style: typography.body),
        const Gap(DsSpacing.section),
        DsFilledButton.primary(onPressed: onRetry, text: '再読み込み'),
        if (onSecondaryAction != null && secondaryActionText != null) ...[
          const Gap(DsSpacing.section),
          DsOutlinedButton.tertiary(
            onPressed: onSecondaryAction,
            text: secondaryActionText!,
          ),
        ],
      ],
    );
  }
}

/// 狭い場所向けのエラー表示。
class _DsCompactErrorView extends StatelessWidget {
  const _DsCompactErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;
    final typography = context.dsTypography;

    return InkWell(
      onTap: onRetry,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.exclamationmark_circle_fill,
                color: colorScheme.error,
                size: DsSize.iconLarge,
              ),
              const Gap(DsSpacing.inline),
              Text(
                'エラー',
                style: typography.itemTitle.copyWith(color: colorScheme.error),
              ),
            ],
          ),
          const Gap(DsSpacing.inline),
          Text('タップで再読み込み', style: typography.itemTitle),
        ],
      ),
    );
  }
}

/// 読み込み中のプレースホルダ。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット261
class DsShimmer extends StatelessWidget {
  /// 矩形のプレースホルダ。
  const DsShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder(
         borderRadius: DsRadius.shimmerBorder,
       );

  /// 円形のプレースホルダ。
  const DsShimmer.circular({
    super.key,
    required this.width,
    required this.height,
  }) : shapeBorder = const CircleBorder();

  /// pill 型のプレースホルダ。ボタンやチップの位置を埋める。
  const DsShimmer.pill({super.key, required this.width, required this.height})
    : shapeBorder = const RoundedRectangleBorder(
        borderRadius: DsRadius.pillBorder,
      );

  /// 幅。
  final double width;

  /// 高さ。
  final double height;

  /// 形。
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;
    return Shimmer.fromColors(
      // surfaceContainerHighest は surfaceVariant と別の色に解決されるため、
      // 見た目を変えないよう移行前と同じ surfaceVariant を使う。
      // M3 移行（#187）で見直す。
      // ignore: deprecated_member_use
      baseColor: colorScheme.surfaceVariant,
      highlightColor: colorScheme.surface,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          // ignore: deprecated_member_use
          color: colorScheme.surfaceVariant,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
