import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'text_theme.dart';

// [BuildContext]を引数で渡すしたくないが、
// [AppBarTheme]の[titleTextStyle]を設定するためにやむを得ず渡している
ThemeData getThemeData(ThemeMode themeMode, BuildContext context) {
  final colorScheme =
      themeMode == ThemeMode.light ? lightColorScheme : darkColorScheme;

  return ThemeData(
    fontFamily: lineFontFamily,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      elevation: 0.1,
      titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: lineFontFamily,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          colorScheme.surface,
        ),
        iconColor: MaterialStateProperty.all<Color>(
          colorScheme.primary,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      selectedLabelStyle: const TextStyle(
        fontFamily: lineFontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: lineFontFamily,
      ),
      elevation: 0.1,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurface,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    // タップ時のエフェクトを無効化
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}
