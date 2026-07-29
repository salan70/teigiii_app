import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for DefinitionsApi
void main() {
  final instance = TeigiiiApi().getDefinitionsApi();

  group(DefinitionsApi, () {
    // 定義を削除（論理削除・30 日保持）
    //
    //Future v1DefinitionsIdDelete(String id) async
    test('test v1DefinitionsIdDelete', () async {
      // TODO
    });

    // 定義詳細を取得
    //
    //Future<DefinitionResponse> v1DefinitionsIdGet(String id) async
    test('test v1DefinitionsIdGet', () async {
      // TODO
    });

    // いいね解除
    //
    //Future v1DefinitionsIdLikeDelete(String id) async
    test('test v1DefinitionsIdLikeDelete', () async {
      // TODO
    });

    // いいね
    //
    //Future v1DefinitionsIdLikePut(String id) async
    test('test v1DefinitionsIdLikePut', () async {
      // TODO
    });

    // いいねしたユーザー一覧
    //
    //Future<V1UsersIdFollowersGet200Response> v1DefinitionsIdLikesGet(String id, { String cursor, int limit }) async
    test('test v1DefinitionsIdLikesGet', () async {
      // TODO
    });

    // 本文編集・状態遷移・（下書きのみ）言葉の変更
    //
    // 許可される遷移: public↔private。本文編集は finalized_at + 1 時間まで。言葉の付け替えは受け付けない。
    //
    //Future<DefinitionResponse> v1DefinitionsIdPatch(String id, { UpdateDefinitionRequest updateDefinitionRequest }) async
    test('test v1DefinitionsIdPatch', () async {
      // TODO
    });

    // 定義を作成（public / private）
    //
    //Future<DefinitionResponse> v1DefinitionsPost({ CreateDefinitionRequest createDefinitionRequest }) async
    test('test v1DefinitionsPost', () async {
      // TODO
    });
  });
}
