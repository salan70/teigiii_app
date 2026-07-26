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
  DsTypography get dsTypography {
    final extension = Theme.of(this).extension<DsTypography>();
    if (extension == null) {
      // Ds のテーマを適用していない環境（テストの素の MaterialApp など）でも
      // 落ちないよう、現在の TextTheme から写像する。
      return DsTypography.fromTextTheme(Theme.of(this).textTheme);
    }
    return extension;
  }

  /// 基本の配色。
  ColorScheme get dsColorScheme => Theme.of(this).colorScheme;
}
