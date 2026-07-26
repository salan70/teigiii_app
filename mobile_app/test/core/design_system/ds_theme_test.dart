import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:teigi_app/core/design_system/theme/ds_color_scheme.dart';

/// 移行前 `getThemeData(ThemeMode, BuildContext)` の実効値を固定する回帰テスト。
///
/// ここが変わることは「意図しない見た目変更」を意味する。
/// 見た目を変える場合は、この期待値を意図として書き換えること。
void main() {
  group('buildDsThemeData', () {
    test('BuildContext なしで light / dark を構築できる', () {
      expect(
        buildDsThemeData(Brightness.light).colorScheme,
        dsLightColorScheme,
      );
      expect(buildDsThemeData(Brightness.dark).colorScheme, dsDarkColorScheme);
    });

    test('Material 2 を維持している', () {
      expect(buildDsThemeData(Brightness.light).useMaterial3, isFalse);
      expect(
        buildDsThemeData(Brightness.light).textTheme.bodyLarge?.fontFamily,
        dsFontFamily,
      );
    });

    test('TextTheme の上書き分が移行前と一致する', () {
      final textTheme = buildDsThemeData(Brightness.light).textTheme;
      expect(textTheme.titleLarge?.fontWeight, FontWeight.bold);
      expect(textTheme.titleMedium?.fontWeight, FontWeight.bold);
      expect(textTheme.bodyLarge?.fontSize, 18);
      // 上書きしていない style はサイズを持たない（geometry は Theme.of で付く）。
      expect(textTheme.titleLarge?.fontSize, isNull);
    });

    for (final brightness in Brightness.values) {
      test('$brightness の AppBar タイトル style が移行前と一致する', () {
        final colorScheme = brightness == Brightness.light
            ? dsLightColorScheme
            : dsDarkColorScheme;
        final style = buildDsThemeData(brightness).appBarTheme.titleTextStyle!;

        // 移行前は MaterialApp より上の context を渡していたため、
        // fallback テーマ（M3）の titleLarge geometry が効いていた。
        expect(style.fontSize, 22.0);
        expect(style.fontWeight, FontWeight.bold);
        expect(style.letterSpacing, 0.0);
        expect(style.fontFamily, dsFontFamily);
        expect(style.color, colorScheme.onSurface);
        expect(style.inherit, isFalse);
      });

      test('$brightness の主要なテーマ値が移行前と一致する', () {
        final theme = buildDsThemeData(brightness);
        final colorScheme = theme.colorScheme;

        expect(theme.appBarTheme.centerTitle, isFalse);
        expect(theme.appBarTheme.backgroundColor, colorScheme.surface);
        expect(theme.appBarTheme.elevation, DsElevation.hairline);
        expect(theme.appBarTheme.iconTheme?.color, colorScheme.onSurface);

        expect(
          theme.bottomNavigationBarTheme.backgroundColor,
          colorScheme.surface,
        );
        expect(
          theme.bottomNavigationBarTheme.selectedItemColor,
          colorScheme.primary,
        );
        expect(theme.bottomNavigationBarTheme.elevation, DsElevation.hairline);
        expect(theme.bottomNavigationBarTheme.selectedLabelStyle?.fontSize, 12);

        expect(theme.tabBarTheme.labelColor, colorScheme.primary);
        expect(theme.tabBarTheme.unselectedLabelColor, colorScheme.onSurface);
        expect(theme.tabBarTheme.indicatorSize, TabBarIndicatorSize.label);

        expect(theme.scaffoldBackgroundColor, colorScheme.surface);
        expect(theme.splashColor, Colors.transparent);
        expect(theme.highlightColor, Colors.transparent);
      });

      test('$brightness で DsColors が ThemeExtension として登録されている', () {
        expect(buildDsThemeData(brightness).extension<DsColors>(), isNotNull);
      });
    }
  });
}
