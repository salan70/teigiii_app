import 'package:flutter/material.dart';

import '../token/ds_colors.dart';
import '../token/ds_elevation.dart';
import 'ds_color_scheme.dart';
import 'ds_text_theme.dart';

/// デザインシステムの [ThemeData] を構築する。
///
/// 呼び出し元の [BuildContext] を必要としない。
///
/// @doc doc/specs/mobile-app-design-system.md#3-トークン-taxonomy
ThemeData buildDsThemeData(Brightness brightness) {
  final colorScheme = brightness == Brightness.light
      ? dsLightColorScheme
      : dsDarkColorScheme;

  final base = ThemeData(
    // Flutter 3.16 以降のデフォルト M3 化による意図しない見た目変更を防ぐ。
    // M3 への移行は #187 の UI 刷新で意図的に行う。
    useMaterial3: false,
    fontFamily: dsFontFamily,
    colorScheme: colorScheme,
    textTheme: dsTextThemeOverrides,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      elevation: DsElevation.hairline,
      titleTextStyle: _appBarTitleTextStyle(colorScheme),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(colorScheme.surface),
        iconColor: MaterialStateProperty.all<Color>(colorScheme.primary),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      selectedLabelStyle: const TextStyle(
        fontFamily: dsFontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(fontFamily: dsFontFamily),
      elevation: DsElevation.hairline,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurface,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    // タップ時のエフェクトを無効化
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );

  // DsTypography はここで登録しない。フォントサイズは `Theme.of` が
  // locale の script category に応じて後から適用するため、
  // 構築時の TextTheme を保持するとサイズが欠落する。
  return base.copyWith(
    extensions: <ThemeExtension<dynamic>>[DsColors.standard],
  );
}

/// AppBar のタイトル style。
///
/// 移行前は `Theme.of(context).textTheme.titleLarge` を使っていたが、
/// その `context` は `MaterialApp` より上にあり、実際に解決されていたのは
/// **アプリのテーマではなく Flutter の fallback テーマ（M3）** だった。
/// 見た目を変えないため、その実効値（M3 の titleLarge geometry + M2 の色）を
/// [BuildContext] なしで再現している。
///
/// M3 への移行（#187）でこの経緯ごと見直す。
TextStyle _appBarTitleTextStyle(ColorScheme colorScheme) {
  return Typography.englishLike2021.titleLarge!
      .merge(
        Typography.blackMountainView.titleLarge!.apply(
          fontFamily: dsFontFamily,
        ),
      )
      .copyWith(
        fontFamily: dsFontFamily,
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      );
}
