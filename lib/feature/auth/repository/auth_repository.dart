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

  /// 匿名ログインを行う
  Future<void> signInAnonymously() => firebaseAuth.signInAnonymously();
}
