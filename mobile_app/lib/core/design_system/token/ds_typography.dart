import 'package:flutter/material.dart';

/// タイポグラフィの semantic token。
///
/// 値は現行の [TextTheme] の実効値をそのまま採用し、用途を表す名前を与えている。
/// 新しいサイズや太さを増やすためのものではない。
///
/// [ThemeExtension] にはしない。[TextTheme] のフォントサイズは
/// `Theme.of` が locale の script category に応じて後から適用するため、
/// [ThemeData] 構築時の値を保持するとサイズが欠落する。
/// 必ず `context.dsTypography` から解決すること。
///
/// @doc doc/specs/mobile-app-design-system.md#3-トークン-taxonomy
@immutable
class DsTypography {
  const DsTypography({
    required this.heading,
    required this.itemTitle,
    required this.sectionLabel,
    required this.body,
    required this.bodyEmphasis,
    required this.label,
  });

  /// [TextTheme] から意味名へ写像する。
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
  bool operator ==(Object other) {
    return other is DsTypography &&
        other.heading == heading &&
        other.itemTitle == itemTitle &&
        other.sectionLabel == sectionLabel &&
        other.body == body &&
        other.bodyEmphasis == bodyEmphasis &&
        other.label == label;
  }

  @override
  int get hashCode =>
      Object.hash(heading, itemTitle, sectionLabel, body, bodyEmphasis, label);
}
