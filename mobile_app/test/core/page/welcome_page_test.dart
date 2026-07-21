import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/welcome_page.dart';

void main() {
  testWidgets('1画面で主文言と同意前の規約導線を表示する', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WelcomePage())),
    );

    expect(find.text('言葉を、自分の言葉で残す辞書です'), findsOneWidget);
    expect(find.text('はじめる'), findsOneWidget);
    expect(find.text('利用規約'), findsOneWidget);
    expect(find.text('プライバシーポリシー'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('文字拡大時も主要操作までスクロールできる', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const WelcomePage(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('はじめる'), findsOneWidget);
  });

  testWidgets('ダークモードでも主要内容を表示する', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: ThemeData.dark(), home: const WelcomePage()),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('言葉を、自分の言葉で残す辞書です'), findsOneWidget);
  });
}
