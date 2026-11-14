import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/core/common_provider/account_cleanup_state_provider.dart';
import 'package:teigi_app/core/common_provider/firebase_providers.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';

import 'auth_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<GoogleSignInClient>(),
  MockSpec<User>(),
  MockSpec<UserCredential>(),
  MockSpec<UserInfo>(),
  MockSpec<AdditionalUserInfo>(),
  MockSpec<FirebaseApp>(),
])
void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignInClient googleSignInClient;
  late GoogleSignInAccount googleAccount;
  late MockUser user;
  late AuthRepository repository;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    googleSignInClient = MockGoogleSignInClient();
    googleAccount = _GoogleAccount();
    user = MockUser();
    repository = AuthRepository(
      firebaseAuth,
      googleSignInClient: googleSignInClient,
    );

    when(
      googleSignInClient.authenticate(),
    ).thenAnswer((_) async => googleAccount);
    when(firebaseAuth.currentUser).thenReturn(user);
  });

  test('Google サインインは取得した ID token で Firebase credential を作る', () async {
    when(
      firebaseAuth.signInWithCredential(any),
    ).thenAnswer((_) async => MockUserCredential());

    await repository.signInWithGoogle();

    final captured =
        verify(firebaseAuth.signInWithCredential(captureAny)).captured.single
            as AuthCredential;
    expect(captured.providerId, 'google.com');
    verify(googleSignInClient.authenticate()).called(1);
  });

  test('Apple 連携は匿名ユーザーの linkWithProvider を使う', () async {
    when(
      user.linkWithProvider(any),
    ).thenAnswer((_) async => MockUserCredential());

    await repository.linkWithApple();

    final captured = verify(user.linkWithProvider(captureAny)).captured.single;
    expect(captured, isA<AppleAuthProvider>());
  });

  test('リンク済み Google アカウントの再認証は Google credential を使う', () async {
    final providerInfo = MockUserInfo();
    when(providerInfo.providerId).thenReturn('google.com');
    when(user.providerData).thenReturn([providerInfo]);
    when(
      user.reauthenticateWithCredential(any),
    ).thenAnswer((_) async => MockUserCredential());

    await repository.reauthenticateWithLinkedProvider();

    final captured =
        verify(user.reauthenticateWithCredential(captureAny)).captured.single
            as AuthCredential;
    expect(captured.providerId, 'google.com');
  });

  test('匿名の削除準備は fresh token のみ更新し再認証しない', () async {
    when(user.uid).thenReturn('A');
    when(user.isAnonymous).thenReturn(true);
    when(user.getIdToken(true)).thenAnswer((_) async => 'fresh-A');
    expect(await repository.prepareAccountDeletion(), 'A');
    verify(user.getIdToken(true)).called(1);
    verifyNever(user.reauthenticateWithProvider(any));
  });

  test('Google 削除準備は再認証後に token を更新', () async {
    final info = MockUserInfo();
    when(info.providerId).thenReturn('google.com');
    when(user.providerData).thenReturn([info]);
    when(user.uid).thenReturn('A');
    when(user.getIdToken(true)).thenAnswer((_) async => 'fresh-A');
    await repository.prepareAccountDeletion();
    verifyInOrder([
      user.reauthenticateWithCredential(any),
      user.getIdToken(true),
    ]);
  });

  for (final withGoogle in [false, true]) {
    test(
      'Apple ${withGoogle ? '+ Google' : '単独'} は Apple 再認証と認可失効を先行',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final apple = MockUserInfo();
        final google = MockUserInfo();
        when(apple.providerId).thenReturn('apple.com');
        when(google.providerId).thenReturn('google.com');
        when(user.providerData).thenReturn([if (withGoogle) google, apple]);
        when(user.uid).thenReturn('A');
        when(user.getIdToken(true)).thenAnswer((_) async => 'fresh-A');
        final result = MockUserCredential();
        final additional = MockAdditionalUserInfo();
        when(additional.authorizationCode).thenReturn('apple-code');
        when(result.additionalUserInfo).thenReturn(additional);
        when(
          user.reauthenticateWithProvider(any),
        ).thenAnswer((_) async => result);
        await repository.prepareAccountDeletion();
        verifyInOrder([
          user.reauthenticateWithProvider(any),
          firebaseAuth.revokeTokenWithAuthorizationCode('apple-code'),
          user.getIdToken(true),
        ]);
        verifyNever(user.reauthenticateWithCredential(any));
      },
    );
  }

  test('Apple 認可コードがない場合は停止', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final apple = MockUserInfo();
    when(apple.providerId).thenReturn('apple.com');
    when(user.providerData).thenReturn([apple]);
    when(
      user.reauthenticateWithProvider(any),
    ).thenAnswer((_) async => MockUserCredential());
    await expectLater(
      repository.prepareAccountDeletion(),
      throwsA(isA<FirebaseAuthException>()),
    );
    verifyNever(firebaseAuth.revokeTokenWithAuthorizationCode(any));
    verifyNever(user.getIdToken(true));
  });

  test('Firebase 削除の再試行は元の UID に限定', () async {
    repository.serverDeletedUserId = 'A';
    when(user.uid).thenReturn('B');
    await expectLater(repository.deletePreparedUser('A'), throwsStateError);
    verifyNever(user.delete());
    when(user.uid).thenReturn('A');
    await repository.deletePreparedUser('A');
    verify(user.delete()).called(1);
    expect(repository.serverDeletedUserId, isNull);
  });

  for (final failAtReauth in [true, false]) {
    test(
      'Apple ${failAtReauth ? '再認証キャンセル' : 'revoke 失敗'}では削除準備を完了しない',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final apple = MockUserInfo();
        when(apple.providerId).thenReturn('apple.com');
        when(user.providerData).thenReturn([apple]);
        final result = MockUserCredential();
        final additional = MockAdditionalUserInfo();
        when(result.additionalUserInfo).thenReturn(additional);
        when(additional.authorizationCode).thenReturn('code');
        if (failAtReauth) {
          when(
            user.reauthenticateWithProvider(any),
          ).thenThrow(FirebaseAuthException(code: 'web-context-cancelled'));
        } else {
          when(
            user.reauthenticateWithProvider(any),
          ).thenAnswer((_) async => result);
          when(
            firebaseAuth.revokeTokenWithAuthorizationCode(any),
          ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
        }
        await expectLater(
          repository.prepareAccountDeletion(),
          throwsA(isA<FirebaseAuthException>()),
        );
        verifyNever(user.getIdToken(true));
        verifyNever(user.delete());
      },
    );
  }

  test('非匿名の復元では破棄対象を捕捉しない', () async {
    expect(await repository.captureAnonymousAccount(), isNull);
    verifyNever(user.getIdToken(any));
  });

  test('Scope 再生成でキャッシュを破棄し、削除途中状態だけ引き継ぐ', () {
    final state = AccountCleanupState();
    final cache = Provider<Object>((ref) => Object());
    ProviderContainer createScope() => ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
        accountCleanupStateProvider.overrideWithValue(state),
      ],
    );
    final first = createScope();
    final oldCache = first.read(cache);
    final oldRepository = first.read(authRepositoryProvider);
    final source = CapturedAnonymousAccount(uid: 'A', idToken: 'token-A')
      ..serverDeleted = true;
    oldRepository
      ..pendingAnonymousCleanup = source
      ..serverDeletedUserId = 'deleting-uid';
    first.dispose();
    final second = createScope();
    addTearDown(second.dispose);
    final newRepository = second.read(authRepositoryProvider);
    expect(identical(oldCache, second.read(cache)), isFalse);
    expect(identical(oldRepository, newRepository), isFalse);
    expect(newRepository.pendingAnonymousCleanup, same(source));
    expect(newRepository.pendingAnonymousCleanup!.serverDeleted, isTrue);
    expect(newRepository.serverDeletedUserId, 'deleting-uid');
    newRepository.pendingAnonymousCleanup = null;
    expect(state.pendingAnonymousCleanup, isNull);
  });

  test('constructor の既定状態は他の repository と共有しない', () {
    repository.serverDeletedUserId = 'A';
    repository.pendingAnonymousCleanup = CapturedAnonymousAccount(
      uid: 'A',
      idToken: 'token-A',
    );
    final other = AuthRepository(firebaseAuth);
    expect(other.serverDeletedUserId, isNull);
    expect(other.pendingAnonymousCleanup, isNull);
  });

  test('macOS では Apple の削除準備を停止する', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final apple = MockUserInfo();
    when(apple.providerId).thenReturn('apple.com');
    when(user.providerData).thenReturn([apple]);
    await expectLater(
      repository.prepareAccountDeletion(),
      throwsA(isA<FirebaseAuthException>()),
    );
    verifyNever(user.reauthenticateWithProvider(any));
    verifyNever(firebaseAuth.revokeTokenWithAuthorizationCode(any));
  });

  test('Firebase 削除失敗後は成功済み backend 削除を繰り返さない', () async {
    final requests = <RequestOptions>[];
    repository = AuthRepository(
      firebaseAuth,
      cleanupDio: Dio()
        ..httpClientAdapter = _CleanupAdapter(
          requests,
          statusCodes: [200, 503, 200],
        ),
    );
    final app = MockFirebaseApp();
    when(firebaseAuth.app).thenReturn(app);
    when(app.options).thenReturn(
      const FirebaseOptions(
        apiKey: 'api-key',
        appId: 'app-id',
        messagingSenderId: 'sender',
        projectId: 'project',
        iosBundleId: 'com.toda.teigiii.dev',
      ),
    );
    when(user.uid).thenReturn('B');
    final source = CapturedAnonymousAccount(uid: 'A', idToken: 'token-A');
    await expectLater(
      repository.deleteCapturedAnonymousAccount(source),
      throwsA(isA<DioException>()),
    );
    expect(repository.pendingAnonymousCleanup, source);
    expect(source.serverDeleted, isTrue);
    await repository.deleteCapturedAnonymousAccount(source);
    expect(requests.map((r) => r.method), ['DELETE', 'POST', 'POST']);
    expect(repository.pendingAnonymousCleanup, isNull);
  });

  test('切替後は固定 A token と AppCheck で backend → REST の順に削除', () async {
    final requests = <RequestOptions>[];
    final dio = Dio()..httpClientAdapter = _CleanupAdapter(requests);
    repository = AuthRepository(
      firebaseAuth,
      cleanupDio: dio,
      getAppCheckToken: () async => 'app-check',
    );
    final app = MockFirebaseApp();
    when(firebaseAuth.app).thenReturn(app);
    when(app.options).thenReturn(
      const FirebaseOptions(
        apiKey: 'api-key',
        appId: 'app-id',
        messagingSenderId: 'sender',
        projectId: 'project',
        iosBundleId: 'com.toda.teigiii.dev',
      ),
    );
    when(user.uid).thenReturn('B');
    final source = CapturedAnonymousAccount(uid: 'A', idToken: 'token-A');
    await repository.deleteCapturedAnonymousAccount(source);
    expect(requests.map((r) => r.method), ['DELETE', 'POST']);
    expect(requests.first.headers['Authorization'], 'Bearer token-A');
    expect(requests.first.headers['X-Firebase-AppCheck'], 'app-check');
    expect(requests.last.data, {'idToken': 'token-A'});
    expect(requests.last.queryParameters['key'], 'api-key');
    expect(requests.last.headers['X-Firebase-AppCheck'], 'app-check');
    expect(
      requests.last.headers['X-Ios-Bundle-Identifier'],
      'com.toda.teigiii.dev',
    );
    expect(source.serverDeleted, isTrue);
    expect(repository.pendingAnonymousCleanup, isNull);
    verifyNever(user.delete());
    verifyNever(user.getIdToken(any));
  });

  for (final (status, code, advances) in [
    (404, 'user_not_found', true),
    (404, 'other_error', false),
    (401, 'user_not_found', false),
  ]) {
    test('A cleanup の $status/$code から REST 続行: $advances', () async {
      final requests = <RequestOptions>[];
      repository = AuthRepository(
        firebaseAuth,
        getAppCheckToken: () async => 'app-check',
        cleanupDio: Dio()
          ..httpClientAdapter = _CleanupAdapter(
            requests,
            statusCodes: [status, 200],
            responseBodies: ['{"error":{"code":"$code","message":"fixture"}}'],
          ),
      );
      final app = MockFirebaseApp();
      when(firebaseAuth.app).thenReturn(app);
      when(app.options).thenReturn(
        const FirebaseOptions(
          apiKey: 'api-key',
          appId: 'app-id',
          messagingSenderId: 'sender',
          projectId: 'project',
          iosBundleId: 'com.toda.teigiii.dev',
        ),
      );
      when(user.uid).thenReturn('B');
      final source = CapturedAnonymousAccount(uid: 'A', idToken: 'token-A');
      if (advances) {
        await repository.deleteCapturedAnonymousAccount(source);
        expect(requests.last.data, {'idToken': 'token-A'});
        expect(repository.pendingAnonymousCleanup, isNull);
      } else {
        await expectLater(
          repository.deleteCapturedAnonymousAccount(source),
          throwsA(isA<ApiException>()),
        );
        expect(repository.pendingAnonymousCleanup, same(source));
      }
      expect(requests.length, advances ? 2 : 1);
      expect(source.serverDeleted, advances);
      verifyNever(user.delete());
    });
  }

  test('切替先が元 UID または匿名なら削除を拒否', () async {
    final requests = <RequestOptions>[];
    repository = AuthRepository(
      firebaseAuth,
      cleanupDio: Dio()..httpClientAdapter = _CleanupAdapter(requests),
    );
    final source = CapturedAnonymousAccount(uid: 'A', idToken: 'token-A');
    when(user.uid).thenReturn('A');
    await expectLater(
      repository.deleteCapturedAnonymousAccount(source),
      throwsStateError,
    );
    when(user.uid).thenReturn('B');
    when(user.isAnonymous).thenReturn(true);
    await expectLater(
      repository.deleteCapturedAnonymousAccount(source),
      throwsStateError,
    );
    expect(requests, isEmpty);
  });
}

class _GoogleAccount extends Fake implements GoogleSignInAccount {
  @override
  GoogleSignInAuthentication get authentication =>
      const GoogleSignInAuthentication(idToken: 'id-token');
}

class _CleanupAdapter implements HttpClientAdapter {
  _CleanupAdapter(
    this.requests, {
    List<int>? statusCodes,
    List<String>? responseBodies,
  }) : statusCodes = statusCodes ?? [],
       responseBodies = responseBodies ?? [];
  final List<RequestOptions> requests;
  final List<int> statusCodes;
  final List<String> responseBodies;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      responseBodies.isEmpty ? '{}' : responseBodies.removeAt(0),
      statusCodes.isEmpty ? 200 : statusCodes.removeAt(0),
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
