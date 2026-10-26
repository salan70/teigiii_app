import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/common_provider/app_scope_reset.dart';
import 'package:teigi_app/feature/auth/application/account_link_service.dart';
import 'package:teigi_app/feature/auth/domain/auth_provider_type.dart';
import 'package:teigi_app/feature/auth/repository/account_data_repository.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';

import 'account_link_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AccountDataRepository>(),
  MockSpec<AppScopeResetController>(),
  MockSpec<AuthRepository>(),
  MockSpec<User>(),
])
void main() {
  late MockAccountDataRepository dataRepository;
  late MockAppScopeResetController scopeReset;
  late MockAuthRepository auth;
  late MockUser user;
  late AccountLinkService service;
  late CapturedAnonymousAccount source;
  final credential = GoogleAuthProvider.credential(idToken: 'credential');
  const data = AccountDataSnapshot(
    definedWordCount: 3,
    savedWordCount: 2,
    followingCount: 1,
    hasEditedProfile: true,
  );

  setUp(() {
    auth = MockAuthRepository();
    dataRepository = MockAccountDataRepository();
    scopeReset = MockAppScopeResetController();
    user = MockUser();
    source = CapturedAnonymousAccount(uid: 'A', idToken: 'token-A');
    when(auth.currentUser).thenReturn(user);
    when(user.uid).thenReturn('A');
    when(auth.captureAnonymousAccount()).thenAnswer((_) async => source);
    when(
      dataRepository.fetchCurrentAccountData(),
    ).thenAnswer((_) async => data);
    when(auth.linkWithGoogle()).thenThrow(
      FirebaseAuthException(
        code: 'credential-already-in-use',
        credential: credential,
      ),
    );
    service = AccountLinkService(
      authRepository: auth,
      accountDataRepository: dataRepository,
      scopeResetController: scopeReset,
    );
  });

  test('通常連携では切替も削除も行わない', () async {
    expect(
      await service.link(
        AuthProviderType.apple,
        confirmDiscard: (_) async => fail('不要な確認'),
      ),
      AccountLinkResult.linked,
    );
    verifyNever(auth.captureAnonymousAccount());
    verifyNever(auth.deleteCapturedAnonymousAccount(any));
    verifyNever(scopeReset.reset());
  });
  test('件数の確認キャンセルでは A は無傷', () async {
    expect(
      await service.link(
        AuthProviderType.google,
        confirmDiscard: (value) async {
          expect(value, data);
          return false;
        },
      ),
      AccountLinkResult.cancelled,
    );
    verifyNever(auth.signInWithCredential(any));
    verifyNever(auth.deleteCapturedAnonymousAccount(any));
  });
  test('データ取得失敗ではサインインも削除も行わない', () async {
    when(
      dataRepository.fetchCurrentAccountData(),
    ).thenThrow(StateError('offline'));
    await expectLater(
      service.link(AuthProviderType.google, confirmDiscard: (_) async => true),
      throwsStateError,
    );
    verifyNever(auth.signInWithCredential(any));
    verifyNever(auth.deleteCapturedAnonymousAccount(any));
  });
  test('B 成功後にだけ捕捉した A を削除する', () async {
    expect(
      await service.link(
        AuthProviderType.google,
        confirmDiscard: (_) async => true,
      ),
      AccountLinkResult.switched,
    );
    verifyInOrder([
      auth.captureAnonymousAccount(),
      auth.signInWithCredential(credential),
      auth.deleteCapturedAnonymousAccount(source),
      scopeReset.reset(),
    ]);
  });
  test('credential 失敗とフォールバックキャンセルでは A を削除しない', () async {
    when(
      auth.signInWithCredential(any),
    ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));
    expect(
      await service.link(
        AuthProviderType.google,
        confirmDiscard: (_) async => true,
        onCredentialFallback: () async => null,
      ),
      AccountLinkResult.cancelled,
    );
    verifyNever(auth.deleteCapturedAnonymousAccount(any));
  });
  test('添付 credential がない衝突も既存プロバイダで認証してから削除', () async {
    when(auth.linkWithGoogle()).thenThrow(
      FirebaseAuthException(code: 'account-exists-with-different-credential'),
    );
    await service.link(
      AuthProviderType.google,
      confirmDiscard: (_) async => true,
      onCredentialFallback: () async => AuthProviderType.apple,
    );
    verifyInOrder([
      auth.signInWithApple(),
      auth.deleteCapturedAnonymousAccount(source),
    ]);
  });
  test('フォールバック認証失敗でも A を削除しない', () async {
    when(
      auth.signInWithCredential(any),
    ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));
    when(
      auth.signInWithApple(),
    ).thenThrow(FirebaseAuthException(code: 'web-context-cancelled'));
    await expectLater(
      service.link(
        AuthProviderType.google,
        confirmDiscard: (_) async => true,
        onCredentialFallback: () async => AuthProviderType.apple,
      ),
      throwsA(isA<FirebaseAuthException>()),
    );
    verifyNever(auth.deleteCapturedAnonymousAccount(any));
  });
  test('復元も匿名 A の確認と B 成功後の削除を行う', () async {
    await service.signIn(
      AuthProviderType.apple,
      confirmDiscard: (_) async => true,
    );
    verifyInOrder([
      auth.captureAnonymousAccount(),
      auth.signInWithApple(),
      auth.deleteCapturedAnonymousAccount(source),
      scopeReset.reset(),
    ]);
  });
  test('匿名 A の復元で確認手段がなければ安全に中断', () async {
    expect(
      await service.signIn(AuthProviderType.apple),
      AccountLinkResult.cancelled,
    );
    verifyNever(auth.signInWithApple());
  });
  test('元アカウントがなければそのまま復元', () async {
    when(auth.captureAnonymousAccount()).thenAnswer((_) async => null);
    await service.signIn(AuthProviderType.apple);
    verify(auth.signInWithApple()).called(1);
    verifyNever(auth.deleteCapturedAnonymousAccount(any));
    verify(scopeReset.reset()).called(1);
  });
  test('A 削除失敗も途中状態として報告し Scope をリセットする', () async {
    when(
      auth.deleteCapturedAnonymousAccount(any),
    ).thenThrow(Exception('offline'));
    await expectLater(
      service.link(AuthProviderType.google, confirmDiscard: (_) async => true),
      throwsA(isA<AccountCleanupPendingException>()),
    );
    verify(auth.signInWithCredential(credential)).called(1);
    verify(scopeReset.reset()).called(1);
  });
  test('途中状態の再試行は同じ A のみを削除する', () async {
    when(auth.pendingAnonymousCleanup).thenReturn(source);
    await service.retryPendingCleanup();
    verify(auth.deleteCapturedAnonymousAccount(source)).called(1);
    verify(scopeReset.reset()).called(1);
    verifyNever(auth.signInWithApple());
  });
}
