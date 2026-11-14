// UI レビュー用の撮影。`just ui-review capture` から実行する（直接は実行しない）。
//
// `targets.json` の対象・状態・バリアントを読み、状態ごとの PNG を
// `UI_REVIEW_OUT` に書く。結果は `results.json` に残し、ギャラリーの生成は
// `ui_review.py` が担う。手順は doc/guides/ui-review.md。
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import '../../test/core/design_system/golden/ds_golden_harness.dart';
import 'components.dart';
import 'scenario.dart';
import 'screens.dart';

const _outDir = String.fromEnvironment('UI_REVIEW_OUT');
const _only = String.fromEnvironment('UI_REVIEW_ONLY');
const _pixelRatio = 2.0;
const _screenHeight = 844.0;
const _componentHeight = 220.0;

final _registry = <String, Map<String, ScenarioBuilder>>{
  ...componentScenarios,
  ...screenScenarios,
};

class _Variant {
  _Variant(Map<String, dynamic> json)
    : id = json['id'] as String,
      brightness = json['theme'] == 'dark' ? Brightness.dark : Brightness.light,
      width = (json['width'] as num).toDouble(),
      textScale = (json['textScale'] as num).toDouble();

  final String id;
  final Brightness brightness;
  final double width;
  final double textScale;
}

void main() {
  final targets =
      jsonDecode(File('tool/ui_review/targets.json').readAsStringSync())
          as Map<String, dynamic>;
  final variants = {
    for (final v in (targets['variants'] as List).cast<Map<String, dynamic>>())
      v['id'] as String: _Variant(v),
  };
  final selected = _only.isEmpty ? null : _only.split(',').toSet();
  final results = <Map<String, Object?>>[];

  setUpAll(() async {
    await loadDsFonts();
    await _loadIconFonts();
  });

  tearDownAll(() {
    File('$_outDir/results.json')
      ..createSync(recursive: true)
      ..writeAsStringSync(jsonEncode(results));
  });

  for (final target
      in (targets['targets'] as List).cast<Map<String, dynamic>>()) {
    final id = target['id'] as String;
    if (selected != null && !selected.contains(id)) continue;
    final isScreen = target['kind'] == 'screen';
    for (final state
        in (target['states'] as List).cast<Map<String, dynamic>>()) {
      final stateId = state['id'] as String;
      final variantIds =
          (state['variants'] as List?)?.cast<String>() ??
          variants.keys.toList();
      for (final variantId in variantIds) {
        final variant = variants[variantId]!;
        final name = '$id / $stateId / $variantId';
        final file = '$id/${stateId}__$variantId.png';
        testWidgets(name, (tester) async {
          final entry = <String, Object?>{
            'id': id,
            'state': stateId,
            'variant': variantId,
            'file': file,
          };
          results.add(entry);
          final warnings = <String>[];
          final originalOnError = FlutterError.onError;
          FlutterError.onError = (details) {
            warnings.add(details.exceptionAsString().split('\n').first);
          };
          try {
            final builder = _registry[id]?[stateId];
            if (builder == null) {
              entry
                ..['status'] = 'missing'
                ..['reason'] = 'capture 側に $id / $stateId の登録がない';
              return;
            }
            await _capture(
              tester,
              builder(),
              variant,
              isScreen: isScreen,
              path: '$_outDir/$file',
            );
            entry['status'] = 'ok';
          } on Object catch (error) {
            entry
              ..['status'] = 'failed'
              ..['reason'] = error.toString().split('\n').first;
          } finally {
            FlutterError.onError = originalOnError;
            if (warnings.isNotEmpty) entry['warnings'] = warnings;
          }
        });
      }
    }
  }
}

/// アイコンのフォント（MaterialIcons、CupertinoIcons など）を読み込む。
///
/// 読み込まないとアイコンが四角で描かれる。アプリ本文のフォントは
/// [loadDsFonts] が読み込むので、ここでは Ds のフォント以外を対象にする。
Future<void> _loadIconFonts() async {
  final manifest =
      jsonDecode(await rootBundle.loadString('FontManifest.json'))
          as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final family = entry['family'] as String;
    if (family == dsFontFamily) continue;
    final loader = FontLoader(family);
    for (final font in (entry['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

Future<void> _capture(
  WidgetTester tester,
  Scenario scenario,
  _Variant variant, {
  required bool isScreen,
  required String path,
}) async {
  final height =
      scenario.height ?? (isScreen ? _screenHeight : _componentHeight);
  tester.view.physicalSize = Size(variant.width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final boundaryKey = GlobalKey();
  await tester.pumpWidget(
    RepaintBoundary(
      key: boundaryKey,
      child: ProviderScope(
        overrides: scenario.overrides,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ja'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ja')],
          theme: buildDsThemeData(variant.brightness),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(variant.textScale)),
            child: child!,
          ),
          home: isScreen
              ? scenario.widget
              : Scaffold(body: Center(child: scenario.widget)),
        ),
      ),
    ),
  );
  await _settle(tester);

  await tester.runAsync(() async {
    final boundary =
        boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: _pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(data!.buffer.asUint8List());
  });
}

/// 状態が落ち着くまで進める。shimmer など止まらないアニメーションがあっても、
/// 一定時間で打ち切って撮る。
Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  try {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 2),
    );
  } on FlutterError {
    // 止まらないアニメーション。その時点の絵を撮る。
  }
}
