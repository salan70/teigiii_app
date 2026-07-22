import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/definition/presentation/post_definition_fab.dart';

void main() {
  Future<void> pumpFab(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(floatingActionButton: PostDefinitionFAB()),
      ),
    );
  }

  testWidgets('初期状態ではアクションラベルを出さない', (tester) async {
    await pumpFab(tester);

    expect(find.text('定義'), findsNothing);
    expect(find.text('言葉'), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('FAB を押すと定義と言葉のテキストボタンが展開される', (tester) async {
    await pumpFab(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('定義'), findsOneWidget);
    expect(find.text('言葉'), findsOneWidget);
  });
}
