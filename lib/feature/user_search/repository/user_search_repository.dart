import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';

part 'user_search_repository.g.dart';

@riverpod
UserSearchRepository userSearchRepository(UserSearchRepositoryRef ref) =>
    UserSearchRepository(ref.watch(teigiiiApiProvider).getSearchApi());

class UserSearchRepository {
  UserSearchRepository(this._searchApi);

  final SearchApi _searchApi;

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
