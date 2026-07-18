import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for WordsApi
void main() {
  final instance = TeigiiiApi().getWordsApi();

  group(WordsApi, () {
    // みんなの辞書の言葉一覧（読み順）
    //
    //Future<V1WordsGet200Response> v1WordsGet({ String cursor, int limit, String subGroup, String filter, String q }) async
    test('test v1WordsGet', () async {
      // TODO
    });

    // 言葉ページの定義一覧
    //
    // scope=mine は自分の定義（下書き含む）、scope=others は他者の公開定義のみ、scope=all は自分 + 他者の公開定義の混在（旧 UI の言葉トップのパリティ）。sort=reactions はいいね数順。
    //
    //Future<V1UsersIdDefinitionsGet200Response> v1WordsIdDefinitionsGet(String id, { String cursor, int limit, String scope, String sort }) async
    test('test v1WordsIdDefinitionsGet', () async {
      // TODO
    });

    // 言葉ページのヘッダ情報を取得
    //
    //Future<WordResponse> v1WordsIdGet(String id) async
    test('test v1WordsIdGet', () async {
      // TODO
    });

    // 作成者修正（表記・よみ）
    //
    // 作成後 1 時間以内かつ他ユーザーによる操作（定義投稿・保存）がない場合のみ、登録者本人が修正できる。条件はサーバーで検証する。
    //
    //Future<WordResponse> v1WordsIdPatch(String id, { UpdateWordRequest updateWordRequest }) async
    test('test v1WordsIdPatch', () async {
      // TODO
    });

    // 言葉の保存を解除
    //
    //Future v1WordsIdSaveDelete(String id) async
    test('test v1WordsIdSaveDelete', () async {
      // TODO
    });

    // 言葉を保存
    //
    //Future v1WordsIdSavePut(String id) async
    test('test v1WordsIdSavePut', () async {
      // TODO
    });

    // 言葉を登録
    //
    // 表記はサーバーで前後トリム + NFC 正規化してから完全一致で重複判定する。
    //
    //Future<WordResponse> v1WordsPost({ CreateWordRequest createWordRequest }) async
    test('test v1WordsPost', () async {
      // TODO
    });
  });
}
