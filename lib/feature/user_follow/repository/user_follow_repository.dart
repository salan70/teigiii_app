import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';

part 'user_follow_repository.g.dart';

@Riverpod(keepAlive: true)
UserFollowRepository userFollowRepository(UserFollowRepositoryRef ref) =>
    UserFollowRepository(ref.watch(teigiiiApiProvider).getUsersApi());

class UserFollowRepository {
  UserFollowRepository(this._usersApi);

  final UsersApi _usersApi;

  /// ログイン中のユーザーが [targetUserId] をフォローする。
  Future<void> follow(String targetUserId) async {
    try {
      await _usersApi.v1UsersIdFollowPut(id: targetUserId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// ログイン中のユーザーが [targetUserId] のフォローを解除する。
  Future<void> unfollow(String targetUserId) async {
    try {
      await _usersApi.v1UsersIdFollowDelete(id: targetUserId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
