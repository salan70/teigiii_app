import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/word_registration_page.dart';

void main() {
  Future<void> pumpPage(WidgetTester tester, {String? initialWord}) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: WordRegistrationPage(initialWord: initialWord),
        ),
      ),
    );
  }

  testWidgets('initialWord があるとき表記欄にプリフィルする', (tester) async {
    await pumpPage(tester, initialWord: '余白');

    expect(find.text('余白'), findsOneWidget);
  });

  testWidgets('initialWord が無いとき表記欄は空', (tester) async {
    await pumpPage(tester);

    final field = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(field.controller?.text ?? field.initialValue ?? '', isEmpty);
  });

  testWidgets('定義追加画面と同じ見た目の骨格を持つ', (tester) async {
    await pumpPage(tester);

    // × で閉じる
    expect(find.byIcon(CupertinoIcons.xmark), findsOneWidget);

    // AppBar 右の登録アクション（下部 FilledButton ではない）
    expect(find.text('登録'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);

    // 定義追加と同系統のラベル・ボーダーなし
    expect(find.text('登録する言葉'), findsOneWidget);
    expect(find.text('言葉のよみ'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    // 完了後ダイアログ用の文言は置かない（トースト＋pop）
    expect(find.text('続けて定義を書く'), findsNothing);
    expect(find.text('完了'), findsNothing);

    final decorators = tester.widgetList<InputDecorator>(
      find.byType(InputDecorator),
    );
    expect(decorators.length, greaterThanOrEqualTo(2));
    for (final decorator in decorators.take(2)) {
      expect(decorator.decoration.border, InputBorder.none);
    }
  });
}
