import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/core/common_provider/app_scope_reset.dart';
import 'package:teigi_app/feature/auth/application/account_link_service.dart';
import 'package:teigi_app/feature/auth/application/auth_service.dart';
import 'package:teigi_app/feature/auth/domain/auth_provider_type.dart';
import 'package:teigi_app/feature/auth/repository/account_data_repository.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';

import 'account_link_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AccountDataRepository>(),
  MockSpec<AppScopeResetController>(),
  MockSpec<AuthRepository>(),
  MockSpec<AuthService>(),
])
void main() {
  late MockAccountDataRepository accountDataRepository;
  late MockAppScopeResetController scopeResetController;
  late MockAuthRepository authRepository;
  late MockAuthService authService;
  late AccountLinkService service;

  const emptyData = AccountDataSnapshot(
    definedWordCount: 0,
    savedWordCount: 0,
    followingCount: 0,
    hasEditedProfile: false,
  );
  const dataWithDefinitions = AccountDataSnapshot(
    definedWordCount: 3,
    savedWordCount: 0,
    followingCount: 0,
    hasEditedProfile: false,
  );

  setUp(() {
    accountDataRepository = MockAccountDataRepository();
    scopeResetController = MockAppScopeResetController();
    authRepository = MockAuthRepository();
    authService = MockAuthService();
    service = AccountLinkService(
      authRepository: authRepository,
      authService: authService,
      accountDataRepository: accountDataRepository,
      scopeResetController: scopeResetController,
    );

    when(
      accountDataRepository.fetchCurrentAccountData(),
    ).thenAnswer((_) async => emptyData);
    when(authService.deleteUserForAccountSwitch()).thenAnswer((_) async {});
  });

  test('連携が成功した場合は現在の UID を維持して完了する', () async {
    when(authRepository.linkWithApple()).thenAnswer((_) async {});

    final result = await service.link(
      AuthProviderType.apple,
      confirmDiscard: (_) async => fail('空のアカウントでは確認しない'),
    );

    expect(result, AccountLinkResult.linked);
    verify(authRepository.linkWithApple()).called(1);
    verifyNever(accountDataRepository.fetchCurrentAccountData());
    verifyNever(authService.deleteUserForAccountSwitch());
    verifyNever(scopeResetController.reset());
  });

  test('復元サインインが成功した場合は ProviderScope を再生成する', () async {
    when(authRepository.signInWithApple()).thenAnswer((_) async {});

    await service.signIn(AuthProviderType.apple);

    verifyInOrder([
      authRepository.signInWithApple(),
      scopeResetController.reset(),
    ]);
  });

  test('衝突した空の匿名アカウントは確認なしで削除して既存 credential に切り替える', () async {
    final credential = GoogleAuthProvider.credential(idToken: 'id-token');
    when(authRepository.linkWithGoogle()).thenThrow(
      FirebaseAuthException(
        code: 'credential-already-in-use',
        credential: credential,
      ),
    );
    when(
      authRepository.signInWithCredential(credential),
    ).thenAnswer((_) async {});

    final result = await service.link(
      AuthProviderType.google,
      confirmDiscard: (_) async => fail('空のアカウントでは確認しない'),
    );

    expect(result, AccountLinkResult.switched);
    verifyInOrder([
      authService.deleteUserForAccountSwitch(),
      authRepository.signInWithCredential(credential),
      scopeResetController.reset(),
    ]);
  });

  test('衝突したデータありの匿名アカウントは確認キャンセルで無傷のまま中断する', () async {
    when(
      accountDataRepository.fetchCurrentAccountData(),
    ).thenAnswer((_) async => dataWithDefinitions);
    final credential = GoogleAuthProvider.credential(idToken: 'id-token');
    when(authRepository.linkWithGoogle()).thenThrow(
      FirebaseAuthException(
        code: 'credential-already-in-use',
        credential: credential,
      ),
    );

    final result = await service.link(
      AuthProviderType.google,
      confirmDiscard: (data) async {
        expect(data, dataWithDefinitions);
        return false;
      },
    );

    expect(result, AccountLinkResult.cancelled);
    verifyNever(authService.deleteUserForAccountSwitch());
    verifyNever(authRepository.signInWithCredential(any));
    verifyNever(scopeResetController.reset());
  });

  test('衝突したデータありの匿名アカウントは確認後に削除して切り替える', () async {
    when(
      accountDataRepository.fetchCurrentAccountData(),
    ).thenAnswer((_) async => dataWithDefinitions);
    final credential = GoogleAuthProvider.credential(idToken: 'id-token');
    when(authRepository.linkWithGoogle()).thenThrow(
      FirebaseAuthException(
        code: 'account-exists-with-different-credential',
        credential: credential,
      ),
    );
    when(
      authRepository.signInWithCredential(credential),
    ).thenAnswer((_) async {});

    final result = await service.link(
      AuthProviderType.google,
      confirmDiscard: (data) async {
        expect(data.definedWordCount, 3);
        return true;
      },
    );

    expect(result, AccountLinkResult.switched);
    verifyInOrder([
      authService.deleteUserForAccountSwitch(),
      authRepository.signInWithCredential(credential),
      scopeResetController.reset(),
    ]);
  });

  test('サーバー側の匿名アカウント削除に失敗した場合は切り替えを中断する', () async {
    final credential = GoogleAuthProvider.credential(idToken: 'id-token');
    when(authRepository.linkWithGoogle()).thenThrow(
      FirebaseAuthException(
        code: 'credential-already-in-use',
        credential: credential,
      ),
    );
    when(
      authService.deleteUserForAccountSwitch(),
    ).thenThrow(ApiException(statusCode: 500));

    await expectLater(
      service.link(AuthProviderType.google, confirmDiscard: (_) async => true),
      throwsA(isA<ApiException>()),
    );

    verifyNever(authRepository.signInWithCredential(any));
    verifyNever(scopeResetController.reset());
  });

  test('添付 credential での切り替えに失敗した場合はフルサインインへフォールバックする', () async {
    final credential = GoogleAuthProvider.credential(idToken: 'id-token');
    when(authRepository.linkWithGoogle()).thenThrow(
      FirebaseAuthException(
        code: 'account-exists-with-different-credential',
        credential: credential,
      ),
    );
    when(
      authRepository.signInWithCredential(credential),
    ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));
    when(authRepository.signInWithApple()).thenAnswer((_) async {});
    when(authRepository.signInWithGoogle()).thenAnswer((_) async {});

    var fallbackCalled = false;
    final result = await service.link(
      AuthProviderType.google,
      confirmDiscard: (_) async => true,
      onCredentialFallback: () async {
        fallbackCalled = true;
        return AuthProviderType.apple;
      },
    );

    expect(result, AccountLinkResult.switched);
    expect(fallbackCalled, isTrue);
    verifyInOrder([
      authService.deleteUserForAccountSwitch(),
      authRepository.signInWithCredential(credential),
      authRepository.signInWithApple(),
      scopeResetController.reset(),
    ]);
  });
}
