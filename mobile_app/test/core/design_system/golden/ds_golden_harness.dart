import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

/// golden 用にアプリのフォントを読み込む。
///
/// 読み込まないとすべての文字が Ahem の四角で描画され、
/// タイポグラフィの差分が検出できない。
Future<void> loadDsFonts() async {
  const fontPaths = [
    'assets/fonts/LINESeedJP_A_OTF_Th.otf',
    'assets/fonts/LINESeedJP_A_OTF_Rg.otf',
    'assets/fonts/LINESeedJP_A_OTF_Bd.otf',
    'assets/fonts/LINESeedJP_A_OTF_Eb.otf',
  ];

  final loader = FontLoader(dsFontFamily);
  for (final path in fontPaths) {
    loader.addFont(rootBundle.load(path));
  }
  await loader.load();
}

/// golden 用に Ds のテーマ配下でウィジェットを pump する。
Future<void> pumpDsGolden(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  Size size = const Size(390, 220),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildDsThemeData(brightness),
      home: Scaffold(body: Center(child: child)),
    ),
  );
  await tester.pumpAndSettle();
}
