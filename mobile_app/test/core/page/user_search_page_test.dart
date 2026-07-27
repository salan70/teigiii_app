import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:teigi_app/core/page/user_search_page.dart';
import 'package:teigi_app/feature/user_search/presentation/search_user_text_field.dart';

void main() {
  testWidgets('画面端から検索欄まで左右 40 になる', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildDsThemeData(Brightness.light),
          home: const UserSearchPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchUserTextField), findsOneWidget);
    expect(tester.getTopLeft(find.byType(TextField)).dx, 40);
  });
}
