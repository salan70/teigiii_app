import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository(
      ref.watch(firebaseAuthProvider),
    );

class AuthRepository {
  AuthRepository(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;

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
}
