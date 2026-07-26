import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:teigi_app/core/page/user_search_result_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_search/application/user_search_state.dart';
import 'package:teigi_app/feature/user_search/presentation/search_user_text_field.dart';

void main() {
  testWidgets('外側の余白を含め画面端から検索欄まで左右 40 になる', (tester) async {
    const searchWord = '123456789';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue('user-1'),
          userIdSearchByPublicIdProvider(
            searchWord,
          ).overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          theme: buildDsThemeData(Brightness.light),
          home: const UserSearchResultPage(searchWord: searchWord),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchUserTextField), findsOneWidget);
    expect(tester.getTopLeft(find.byType(TextField)).dx, 40);
  });
}
