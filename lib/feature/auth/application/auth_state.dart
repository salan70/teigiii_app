import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/auth_repository.dart';

part 'auth_state.g.dart';

/// ユーザーの状態を監視する
@Riverpod(keepAlive: true)
Stream<User?> userChanges(UserChangesRef ref) =>
    ref.watch(authRepositoryProvider).userChanges;

/// 現在ログインしているユーザーのIDを返す
///
/// ログインしていない場合はnullを返す
///
/// [userChangesProvider]をwatchしているため、ユーザーの状態が変更されるたびに更新される
@Riverpod(keepAlive: true)
String? userId(UserIdRef ref) {
  ref.watch(userChangesProvider);
  return ref.watch(authRepositoryProvider).currentUser?.uid;
}

/// 現在ログインしているかどうかを返す
///
/// [userChangesProvider]をwatchしているため、ユーザーの状態が変更されるたびに更新される
@Riverpod(keepAlive: true)
bool isSignedIn(IsSignedInRef ref) {
  ref.watch(userChangesProvider);
  return ref.watch(authRepositoryProvider).currentUser != null;
}
