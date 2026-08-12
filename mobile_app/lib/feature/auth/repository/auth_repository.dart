import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepository(ref.watch(firebaseAuthProvider));

class AuthRepository {
  AuthRepository(this.firebaseAuth, {GoogleSignInClient? googleSignInClient})
    : _googleSignInClient = googleSignInClient ?? FirebaseGoogleSignInClient();

  final FirebaseAuth firebaseAuth;
  final GoogleSignInClient _googleSignInClient;

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
