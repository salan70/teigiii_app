import 'package:flutter/material.dart';

import 'ds_colors.dart';
import 'ds_typography.dart';

/// テーマ依存トークンへの型安全なアクセスを提供する。
///
/// 余白・角丸・サイズ・標高・不透明度はテーマで変わらないため、
/// `DsSpacing` などの static member を直接使う。
extension DsThemeContext on BuildContext {
  /// [ColorScheme] で表せない意味色。
  DsColors get dsColors =>
      Theme.of(this).extension<DsColors>() ?? DsColors.standard;

  /// タイポグラフィの semantic token。
  ///
  /// `Theme.of` が geometry（フォントサイズ）を適用した後の [TextTheme] から
  /// 写像する。[ThemeData] 構築時の値を使うとサイズが欠落する。
  DsTypography get dsTypography =>
      DsTypography.fromTextTheme(Theme.of(this).textTheme);

  /// 基本の配色。
  ColorScheme get dsColorScheme => Theme.of(this).colorScheme;
}
