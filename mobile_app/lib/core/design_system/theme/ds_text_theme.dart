import 'package:flutter/material.dart';

/// アプリ全体で使うフォントファミリー。
const dsFontFamily = 'LINESeedJP';

/// [ThemeData] に渡す [TextTheme] の上書き分。
///
/// ここで指定していない style は Flutter のデフォルト値が使われる。
/// feature からは意味名でアクセスするため、`DsTypography` を使う。
const dsTextThemeOverrides = TextTheme(
  titleLarge: TextStyle(fontWeight: FontWeight.bold),
  titleMedium: TextStyle(fontWeight: FontWeight.bold),
  bodyLarge: TextStyle(fontSize: 18),
);
