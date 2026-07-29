import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for MeApi
void main() {
  final instance = TeigiiiApi().getMeApi();

  group(MeApi, () {
    // 定義済みの言葉一覧（言葉単位 + 状態別件数）
    //
    //Future<V1MeDefinedWordsGet200Response> v1MeDefinedWordsGet({ String cursor, int limit }) async
    test('test v1MeDefinedWordsGet', () async {
      // TODO
    });

    // 自分の定義一覧（状態で絞り込み）
    //
    //Future<V1UsersIdDefinitionsGet200Response> v1MeDefinitionsGet({ String cursor, int limit, String status }) async
    test('test v1MeDefinitionsGet', () async {
      // TODO
    });

    // あなたの辞書の概要（各件数 + 最近の定義）
    //
    //Future<MyDictionaryOverview> v1MeDictionaryOverviewGet() async
    test('test v1MeDictionaryOverviewGet', () async {
      // TODO
    });

    // ミュート中のユーザー一覧
    //
    //Future<V1UsersIdFollowersGet200Response> v1MeMutesGet({ String cursor, int limit }) async
    test('test v1MeMutesGet', () async {
      // TODO
    });

    // 保存した言葉の一覧
    //
    //Future<V1MeSavedWordsGet200Response> v1MeSavedWordsGet({ String cursor, int limit }) async
    test('test v1MeSavedWordsGet', () async {
      // TODO
    });
  });
}
