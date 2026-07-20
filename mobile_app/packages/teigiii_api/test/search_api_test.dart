import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for SearchApi
void main() {
  final instance = TeigiiiApi().getSearchApi();

  group(SearchApi, () {
    // ユーザーを検索（表示名・ユーザー ID の部分一致）
    //
    //Future<V1UsersIdFollowersGet200Response> v1SearchUsersGet(String q, { String cursor, int limit }) async
    test('test v1SearchUsersGet', () async {
      // TODO
    });

    // 言葉を検索（表記・よみの部分一致）
    //
    //Future<V1WordsGet200Response> v1SearchWordsGet(String q, { String cursor, int limit }) async
    test('test v1SearchWordsGet', () async {
      // TODO
    });
  });
}
