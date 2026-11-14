import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:teigi_app/core/page/account_link_page.dart';
import 'package:teigi_app/feature/auth/application/account_link_service.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';

import '../../feature/auth/application/account_link_service_test.mocks.dart';

void main() {
  late MockAuthRepository auth;
  late AccountLinkService service;
  setUp(() {
    auth = MockAuthRepository();
    service = AccountLinkService(
      authRepository: auth,
      accountDataRepository: MockAccountDataRepository(),
      scopeResetController: MockAppScopeResetController(),
    );
  });
  testWidgets('匿名ユーザーには Apple と Google の連携操作を表示する', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountLinkServiceProvider.overrideWithValue(service),
          isAnonymousProvider.overrideWithValue(true),
          linkedAuthProvidersProvider.overrideWithValue(const []),
        ],
        child: MaterialApp(
          theme: buildDsThemeData(Brightness.light),
          home: const AccountLinkPage(),
        ),
      ),
    );

    expect(find.text('アカウントを保護する'), findsOneWidget);
    expect(find.text('Apple と連携する'), findsOneWidget);
    expect(find.text('Google と連携する'), findsOneWidget);
  });

  testWidgets('連携済みユーザーには連携ボタンを表示しない', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountLinkServiceProvider.overrideWithValue(service),
          isAnonymousProvider.overrideWithValue(false),
          linkedAuthProvidersProvider.overrideWithValue(const []),
        ],
        child: MaterialApp(
          theme: buildDsThemeData(Brightness.light),
          home: const AccountLinkPage(),
        ),
      ),
    );

    expect(find.text('連携済みのアカウント'), findsOneWidget);
    expect(find.text('Apple と連携する'), findsNothing);
    expect(find.text('Google と連携する'), findsNothing);
  });

  testWidgets('切替元の削除途中状態と再試行ボタンを表示する', (tester) async {
    when(
      auth.pendingAnonymousCleanup,
    ).thenReturn(CapturedAnonymousAccount(uid: 'A', idToken: 'token-A'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountLinkServiceProvider.overrideWithValue(service),
          isAnonymousProvider.overrideWithValue(false),
          linkedAuthProvidersProvider.overrideWithValue(const []),
        ],
        child: MaterialApp(
          theme: buildDsThemeData(Brightness.light),
          home: const AccountLinkPage(),
        ),
      ),
    );
    expect(find.text('元の匿名アカウントの削除を再試行'), findsOneWidget);
    expect(find.textContaining('削除が完了していません'), findsOneWidget);
  });
}
