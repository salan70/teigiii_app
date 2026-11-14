import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../core/api/auth_interceptor.dart';
import '../../../core/common_provider/account_cleanup_state_provider.dart';
import '../../../core/common_provider/firebase_providers.dart';
import '../domain/account_cleanup_state.dart';

export '../domain/account_cleanup_state.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository(
  ref.watch(firebaseAuthProvider),
  getAppCheckToken: () => ref.read(firebaseAppCheckProvider).getToken(),
  cleanupState: ref.watch(accountCleanupStateProvider),
);

class AuthRepository {
  AuthRepository(
    this.firebaseAuth, {
    GoogleSignInClient? googleSignInClient,
    TokenProvider? getAppCheckToken,
    Dio? cleanupDio,
    AccountCleanupState? cleanupState,
  }) : _googleSignInClient = googleSignInClient ?? FirebaseGoogleSignInClient(),
       _cleanupState = cleanupState ?? AccountCleanupState(),
       _getAppCheckToken = getAppCheckToken ?? (() async => null),
       _cleanupDio =
           cleanupDio ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 10),
             ),
           );

  final FirebaseAuth firebaseAuth;
  final GoogleSignInClient _googleSignInClient;
  final TokenProvider _getAppCheckToken;
  final Dio _cleanupDio;

  // UID と処理段階を保持し、通信失敗後に別ユーザーを削除しない。
  final AccountCleanupState _cleanupState;
  String? get serverDeletedUserId => _cleanupState.serverDeletedUserId;
  set serverDeletedUserId(String? value) =>
      _cleanupState.serverDeletedUserId = value;
  CapturedAnonymousAccount? get pendingAnonymousCleanup =>
      _cleanupState.pendingAnonymousCleanup;
  set pendingAnonymousCleanup(CapturedAnonymousAccount? value) =>
      _cleanupState.pendingAnonymousCleanup = value;

  Future<CapturedAnonymousAccount?> captureAnonymousAccount() async {
    final user = currentUser;
    if (user == null || !user.isAnonymous) {
      return null;
    }
    final token = await user.getIdToken(true);
    if (token == null || token.isEmpty || currentUser?.uid != user.uid) {
      throw StateError('切替元の認証を確認できませんでした。');
    }
    return CapturedAnonymousAccount(uid: user.uid, idToken: token);
  }

  /// B への切替成功後、捕捉した A の認証だけを用いて削除する。
  Future<void> deleteCapturedAnonymousAccount(
    CapturedAnonymousAccount account,
  ) async {
    final target = currentUser;
    if (target == null || target.isAnonymous || target.uid == account.uid) {
      throw StateError('切替先のサインインを確認できませんでした。');
    }
    pendingAnonymousCleanup = account;
    final bundleId = firebaseAuth.app.options.iosBundleId;
    if (bundleId == null || bundleId.isEmpty) {
      throw StateError('iOS のアプリ設定を確認できませんでした。');
    }
    final appCheckToken = await _getAppCheckToken();
    if (!account.serverDeleted) {
      try {
        await _cleanupDio.delete<void>(
          '$apiBaseUrl/v1/users/me',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${account.idToken}',
              'X-Firebase-AppCheck': appCheckToken,
            },
          ),
        );
      } on DioException catch (exception) {
        final error = ApiException.fromDioException(exception);
        // A の検証済み token に対する「未登録/削除済み」だけを許容する。
        if (error.statusCode != 404 || error.code != 'user_not_found') {
          throw error;
        }
      }
      account.serverDeleted = true;
    }
    // switch 後の User.delete() は使わず、A の ID token で対象を固定する。
    await _cleanupDio.post<void>(
      'https://identitytoolkit.googleapis.com/v1/accounts:delete',
      queryParameters: {'key': firebaseAuth.app.options.apiKey},
      data: {'idToken': account.idToken},
      options: Options(
        headers: {
          'X-Firebase-AppCheck': appCheckToken,
          'X-Ios-Bundle-Identifier': bundleId,
        },
      ),
    );
    pendingAnonymousCleanup = null;
  }

  /// 破壊的なサーバー操作より前に再認証・Apple の認可失効を完了する。
  Future<String> prepareAccountDeletion() async {
    final user = currentUser;
    if (user == null) {
      throw StateError('ログイン中のユーザーが存在しません。');
    }
    if (!user.isAnonymous) {
      final hasApple = user.providerData.any(
        (p) => p.providerId == 'apple.com',
      );
      if (hasApple) {
        if (defaultTargetPlatform != TargetPlatform.iOS) {
          throw FirebaseAuthException(
            code: 'apple-revocation-unsupported',
            message: 'Apple の連携解除には iOS 端末でアカウントを削除してください。',
          );
        }
        final result = await user.reauthenticateWithProvider(_appleProvider());
        final code = result.additionalUserInfo?.authorizationCode;
        if (code == null || code.isEmpty) {
          throw FirebaseAuthException(
            code: 'apple-authorization-code-missing',
            message: 'Apple の認可を取り消せませんでした。削除は中断しました。',
          );
        }
        await firebaseAuth.revokeTokenWithAuthorizationCode(code);
      } else {
        await reauthenticateWithLinkedProvider();
      }
    }
    if (currentUser?.uid != user.uid) {
      throw StateError('再認証中にアカウントが変更されました。');
    }
    final token = await user.getIdToken(true);
    if (token == null || token.isEmpty || currentUser?.uid != user.uid) {
      throw StateError('認証を更新できませんでした。');
    }
    return user.uid;
  }

  Future<void> deletePreparedUser(String uid) async {
    if (currentUser?.uid != uid || serverDeletedUserId != uid) {
      throw StateError('削除対象のアカウントが変更されました。');
    }
    try {
      await currentUser!.delete();
    } on FirebaseAuthException catch (exception) {
      if (exception.code != 'requires-recent-login') {
        rethrow;
      }
      final authenticatedUid = await prepareAccountDeletion();
      if (authenticatedUid != uid || currentUser?.uid != uid) {
        throw StateError('削除対象のアカウントが変更されました。');
      }
      await currentUser!.delete();
    }
    serverDeletedUserId = null;
  }

  /// ログイン中のユーザーを取得
  ///
  /// ログインしていない場合はnullを返す
  User? get currentUser => firebaseAuth.currentUser;

  /// ログイン中のユーザーの状態を監視
  /// ユーザーの状態が変更されるたびに更新される
  Stream<User?> get userChanges => firebaseAuth.userChanges();

  /// 匿名ログインを行う
  Future<void> signInAnonymously() => firebaseAuth.signInAnonymously();

  /// ログアウトを行う
  Future<void> signOut() => firebaseAuth.signOut();

  /// ユーザーを削除する
  Future<void> deleteUser() => currentUser!.delete();

  /// Apple アカウントを現在の匿名アカウントへリンクする。
  Future<void> linkWithApple() async {
    await currentUser!.linkWithProvider(_appleProvider());
  }

  /// Google アカウントを現在の匿名アカウントへリンクする。
  Future<void> linkWithGoogle() async {
    await currentUser!.linkWithCredential(await _googleCredential());
  }

  /// Apple アカウントでサインインする。
  Future<void> signInWithApple() async {
    await firebaseAuth.signInWithProvider(_appleProvider());
  }

  /// Google アカウントでサインインする。
  Future<void> signInWithGoogle() async {
    await firebaseAuth.signInWithCredential(await _googleCredential());
  }

  /// 衝突時に Firebase が返した credential でサインインする。
  Future<void> signInWithCredential(AuthCredential credential) async {
    await firebaseAuth.signInWithCredential(credential);
  }

  /// 現在のアカウントを Apple で再認証する。
  Future<void> reauthenticateWithApple() async {
    await currentUser!.reauthenticateWithProvider(_appleProvider());
  }

  /// 現在のアカウントを Google で再認証する。
  Future<void> reauthenticateWithGoogle() async {
    await currentUser!.reauthenticateWithCredential(await _googleCredential());
  }

  /// 現在のアカウントにリンクされているプロバイダで再認証する。
  Future<void> reauthenticateWithLinkedProvider() async {
    final providerIds = currentUser?.providerData.map(
      (info) => info.providerId,
    );
    final providerId = providerIds?.firstWhere(
      (id) => id != 'firebase',
      orElse: () => '',
    );

    switch (providerId) {
      case 'apple.com':
        await reauthenticateWithApple();
      case 'google.com':
        await reauthenticateWithGoogle();
      default:
        throw StateError('再認証に対応していないプロバイダです。');
    }
  }

  Future<AuthCredential> _googleCredential() async {
    final account = await _googleSignInClient.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError('Google の ID token を取得できませんでした。');
    }
    return GoogleAuthProvider.credential(idToken: idToken);
  }

  AppleAuthProvider _appleProvider() => AppleAuthProvider()..addScope('email');
}

// DI 境界として Google Sign-In SDK を抽象化するための単一メソッドインターフェース。
// ignore: one_member_abstracts
abstract interface class GoogleSignInClient {
  Future<GoogleSignInAccount> authenticate();
}

class FirebaseGoogleSignInClient implements GoogleSignInClient {
  Future<void>? _initializeFuture;

  @override
  Future<GoogleSignInAccount> authenticate() async {
    await (_initializeFuture ??= GoogleSignIn.instance.initialize());
    return GoogleSignIn.instance.authenticate();
  }
}
