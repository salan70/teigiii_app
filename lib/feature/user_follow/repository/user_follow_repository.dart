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

  /// [userId] がフォローしているユーザーのIDリストを全て取得する。
  ///
  /// フォロー中フィードのクライアント側 JOIN が残っている間の暫定実装。
  /// サーバー側 JOIN（`GET /v1/timeline/following`）への切替で不要になる。
  Future<List<String>> fetchAllFollowingIdList(String userId) async {
    try {
      final idList = <String>[];
      String? cursor;
      do {
        final response = await _usersApi.v1UsersIdFollowingGet(
          id: userId,
          cursor: cursor,
          limit: 50,
        );
        final page = response.data!;
        idList.addAll(page.items.map((item) => item.id));
        cursor = page.nextCursor;
      } while (cursor != null);
      return idList;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
