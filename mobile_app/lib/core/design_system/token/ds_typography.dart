import 'package:flutter/material.dart';

/// タイポグラフィの semantic token。
///
/// 値は現行の [TextTheme] の実効値をそのまま採用し、用途を表す名前を与えている。
/// 新しいサイズや太さを増やすためのものではない。
///
/// @doc doc/specs/mobile-app-design-system.md#3-トークン-taxonomy
@immutable
class DsTypography extends ThemeExtension<DsTypography> {
  const DsTypography({
    required this.heading,
    required this.itemTitle,
    required this.sectionLabel,
    required this.body,
    required this.bodyEmphasis,
    required this.label,
  });

  /// [TextTheme] から意味名へ写像する。
  ///
  /// [ThemeData] が構築した実効値を使うため、既存の見た目と一致する。
  factory DsTypography.fromTextTheme(TextTheme textTheme) {
    return DsTypography(
      heading: textTheme.titleLarge!,
      itemTitle: textTheme.titleMedium!,
      sectionLabel: textTheme.titleSmall!,
      body: textTheme.bodyMedium!,
      bodyEmphasis: textTheme.bodyLarge!,
      label: textTheme.labelLarge!,
    );
  }

  /// 画面・セクションの主見出し。
  final TextStyle heading;

  /// リスト項目やフォーム部品の見出し。
  final TextStyle itemTitle;

  /// 設定画面のグループ見出しなど、補助的なラベル。
  final TextStyle sectionLabel;

  /// 本文。
  final TextStyle body;

  /// 強調した本文（定義本文など、読ませることが主目的のテキスト）。
  final TextStyle bodyEmphasis;

  /// ボタンや索引など、操作・目印としてのラベル。
  final TextStyle label;

  @override
  DsTypography copyWith({
    TextStyle? heading,
    TextStyle? itemTitle,
    TextStyle? sectionLabel,
    TextStyle? body,
    TextStyle? bodyEmphasis,
    TextStyle? label,
  }) {
    return DsTypography(
      heading: heading ?? this.heading,
      itemTitle: itemTitle ?? this.itemTitle,
      sectionLabel: sectionLabel ?? this.sectionLabel,
      body: body ?? this.body,
      bodyEmphasis: bodyEmphasis ?? this.bodyEmphasis,
      label: label ?? this.label,
    );
  }

  @override
  DsTypography lerp(ThemeExtension<DsTypography>? other, double t) {
    if (other is! DsTypography) {
      return this;
    }
    return DsTypography(
      heading: TextStyle.lerp(heading, other.heading, t)!,
      itemTitle: TextStyle.lerp(itemTitle, other.itemTitle, t)!,
      sectionLabel: TextStyle.lerp(sectionLabel, other.sectionLabel, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyEmphasis: TextStyle.lerp(bodyEmphasis, other.bodyEmphasis, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
    );
  }
}
