import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/user_search_result.dart';
import '../domain/user_search_result_state.dart';

part 'user_search_repository.g.dart';

@riverpod
UserSearchRepository userSearchRepository(UserSearchRepositoryRef ref) =>
    UserSearchRepository(ref.watch(teigiiiApiProvider).getSearchApi());

class UserSearchRepository {
  UserSearchRepository(this._searchApi);

  final SearchApi _searchApi;

  Future<UserSearchResultState> search(String query, String? cursor) async {
    try {
      final response = await _searchApi.v1SearchUsersGet(
        q: query,
        cursor: cursor,
      );
      final page = response.data!;
      return UserSearchResultState(
        list: page.items
            .map(
              (item) => UserSearchResult(
                id: item.id,
                publicId: item.publicId,
                name: item.name,
                avatarUrl: item.avatarUrl,
              ),
            )
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// [publicId] からユーザー ID を取得する。
  ///
  /// 該当するユーザーが存在しない場合はnullを返す。
  Future<String?> searchByPublicId(String publicId) async {
    try {
      // サーバーは部分一致検索のため、完全一致は最初のページ以外にも
      // 現れうる。cursor が尽きるまで全ページを走査して完全一致のみを探す。
      String? cursor;
      do {
        final response = await _searchApi.v1SearchUsersGet(
          q: publicId,
          cursor: cursor,
          limit: 50,
        );
        final page = response.data!;

        for (final item in page.items) {
          if (item.publicId == publicId) {
            return item.id;
          }
        }
        cursor = page.nextCursor;
      } while (cursor != null);

      return null;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
