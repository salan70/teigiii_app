import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

/// Ds コンポーネントを Ds のテーマ配下で pump する。
Future<void> pumpDsWidget(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: buildDsThemeData(brightness),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
