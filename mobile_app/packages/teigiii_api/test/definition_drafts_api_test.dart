import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for DefinitionDraftsApi
void main() {
  final instance = TeigiiiApi().getDefinitionDraftsApi();

  group(DefinitionDraftsApi, () {
    // 本人の Draft を冪等に削除
    //
    //Future v1DefinitionDraftsIdDelete(String id) async
    test('test v1DefinitionDraftsIdDelete', () async {
      // TODO
    });

    // Draft を定義として冪等に確定
    //
    //Future<DefinitionResponse> v1DefinitionDraftsIdFinalizePost(String id, { FinalizeDefinitionDraftRequest finalizeDefinitionDraftRequest }) async
    test('test v1DefinitionDraftsIdFinalizePost', () async {
      // TODO
    });

    // 本人の定義 Draft を取得
    //
    //Future<DefinitionDraftResponse> v1DefinitionDraftsIdGet(String id) async
    test('test v1DefinitionDraftsIdGet', () async {
      // TODO
    });

    // 定義 Draft を冪等に保存
    //
    //Future<DefinitionDraftResponse> v1DefinitionDraftsIdPut(String id, { PutDefinitionDraftRequest putDefinitionDraftRequest }) async
    test('test v1DefinitionDraftsIdPut', () async {
      // TODO
    });

    // 本人の未確定 Draft 一覧（更新日時降順）
    //
    //Future<V1MeDefinitionDraftsGet200Response> v1MeDefinitionDraftsGet({ String cursor, int limit }) async
    test('test v1MeDefinitionDraftsGet', () async {
      // TODO
    });
  });
}
