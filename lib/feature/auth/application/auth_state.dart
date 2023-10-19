import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/auth_repository.dart';

part 'auth_state.g.dart';


/// 現在ログインしているユーザーのIDを取得する
/// 
/// ログインしていない場合はnullを返す
@Riverpod(keepAlive: true)
Future<String?> userId(UserIdRef ref) async {
  return ref.watch(authRepositoryProvider).currentUser?.uid;
}
