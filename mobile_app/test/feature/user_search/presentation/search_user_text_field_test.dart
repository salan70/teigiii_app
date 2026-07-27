import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:teigi_app/feature/user_search/presentation/search_user_text_field.dart';

void main() {
  testWidgets('DsSearchField を使い高さ 48・左右余白 40 を持つ', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildDsThemeData(Brightness.light),
          home: Scaffold(body: SearchUserTextField()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DsSearchField), findsOneWidget);

    final screenWidth = tester.getSize(find.byType(Scaffold)).width;
    final fieldSize = tester.getSize(find.byType(TextField));
    final fieldLeft = tester.getTopLeft(find.byType(TextField)).dx;

    expect(fieldSize.height, 48);
    expect(fieldLeft, 40);
    expect(fieldSize.width, screenWidth - 40 * 2);
  });
}
