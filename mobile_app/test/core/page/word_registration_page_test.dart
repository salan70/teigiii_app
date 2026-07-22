import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/word_registration_page.dart';

void main() {
  testWidgets('initialWord があるとき表記欄にプリフィルする', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: WordRegistrationPage(initialWord: '余白')),
      ),
    );

    expect(find.text('余白'), findsOneWidget);
  });

  testWidgets('initialWord が無いとき表記欄は空', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WordRegistrationPage())),
    );

    final field = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(field.controller?.text ?? '', isEmpty);
  });
}
