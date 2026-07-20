import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../domain/user_id_list_state.dart';

part 'fetch_user_list_repository.g.dart';

@Riverpod(keepAlive: true)
FetchUserListRepository fetchUserListRepository(
  FetchUserListRepositoryRef ref,
) {
  final api = ref.watch(teigiiiApiProvider);
  return FetchUserListRepository(api.getUsersApi(), api.getDefinitionsApi());
}

/// ユーザー ID 一覧を Workers API から取得する Repository。
///
/// @doc doc/specs/legacy-repository-api-mapping.md#ユーザー-フォロー-ミュート
class FetchUserListRepository {
  FetchUserListRepository(this._usersApi, this._definitionsApi);

  final UsersApi _usersApi;
  final DefinitionsApi _definitionsApi;

  Future<UserIdListState> fetchFollowingIdList(
    String userId,
    String? cursor,
  ) async {
    try {
      final response = await _usersApi.v1UsersIdFollowingGet(
        id: userId,
        cursor: cursor,
        limit: fetchLimitForUserIdList,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<UserIdListState> fetchFollowerIdList(
    String userId,
    String? cursor,
  ) async {
    try {
      final response = await _usersApi.v1UsersIdFollowersGet(
        id: userId,
        cursor: cursor,
        limit: fetchLimitForUserIdList,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<UserIdListState> fetchLikedUserIdList(
    String definitionId,
    String? cursor,
  ) async {
    try {
      final response = await _definitionsApi.v1DefinitionsIdLikesGet(
        id: definitionId,
        cursor: cursor,
        limit: fetchLimitForUserIdList,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  UserIdListState _toState(V1UsersIdFollowersGet200Response page) =>
      UserIdListState(
        list: page.items.map((item) => item.id).toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
}
