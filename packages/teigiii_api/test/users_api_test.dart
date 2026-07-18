import 'package:test/test.dart';
import 'package:teigiii_api/teigiii_api.dart';

/// tests for UsersApi
void main() {
  final instance = TeigiiiApi().getUsersApi();

  group(UsersApi, () {
    // 認証付きアバター画像を取得
    //
    // 非公開 R2 bucket の画像を認証済み利用者へ配信する。
    //
    //Future<Uint8List> v1AvatarsIdGet(String id) async
    test('test v1AvatarsIdGet', () async {
      // TODO
    });

    // ユーザーの定義一覧
    //
    // 対象が本人の場合は非公開定義を含む（下書きは /me/definitions）。他者の場合は公開定義のみ。wordId・subGroup で絞り込み可能。sort=reading は言葉のよみ昇順（旧 UI の頭文字別辞書のパリティ）。
    //
    //Future<V1UsersIdDefinitionsGet200Response> v1UsersIdDefinitionsGet(String id, { String cursor, int limit, String wordId, String subGroup, String sort }) async
    test('test v1UsersIdDefinitionsGet', () async {
      // TODO
    });

    // 公開辞書を取得（言葉単位）
    //
    //Future<V1UsersIdDictionaryGet200Response> v1UsersIdDictionaryGet(String id, { String cursor, int limit }) async
    test('test v1UsersIdDictionaryGet', () async {
      // TODO
    });

    // フォロー解除
    //
    //Future v1UsersIdFollowDelete(String id) async
    test('test v1UsersIdFollowDelete', () async {
      // TODO
    });

    // フォロー
    //
    //Future v1UsersIdFollowPut(String id) async
    test('test v1UsersIdFollowPut', () async {
      // TODO
    });

    // フォロワー一覧
    //
    //Future<V1UsersIdFollowersGet200Response> v1UsersIdFollowersGet(String id, { String cursor, int limit }) async
    test('test v1UsersIdFollowersGet', () async {
      // TODO
    });

    // フォロー中一覧
    //
    //Future<V1UsersIdFollowersGet200Response> v1UsersIdFollowingGet(String id, { String cursor, int limit }) async
    test('test v1UsersIdFollowingGet', () async {
      // TODO
    });

    // 公開プロフィールを取得
    //
    //Future<UserResponse> v1UsersIdGet(String id) async
    test('test v1UsersIdGet', () async {
      // TODO
    });

    // ユーザーがいいねした定義の一覧（いいね日時の降順）
    //
    // 旧 UI のプロフィール「いいね」タブのパリティ用。他者の公開定義に加え、閲覧者自身の定義は非公開でも含める（旧実装と同じ可視性）。
    //
    //Future<V1UsersIdDefinitionsGet200Response> v1UsersIdLikedDefinitionsGet(String id, { String cursor, int limit }) async
    test('test v1UsersIdLikedDefinitionsGet', () async {
      // TODO
    });

    // ミュート解除
    //
    //Future v1UsersIdMuteDelete(String id) async
    test('test v1UsersIdMuteDelete', () async {
      // TODO
    });

    // ミュート
    //
    //Future v1UsersIdMutePut(String id) async
    test('test v1UsersIdMutePut', () async {
      // TODO
    });

    // アバター画像を削除
    //
    //Future v1UsersMeAvatarDelete() async
    test('test v1UsersMeAvatarDelete', () async {
      // TODO
    });

    // アバター画像をアップロード
    //
    // バイナリを直接送信し、Workers 経由で R2 に保存する。
    //
    //Future<V1UsersMeAvatarPut200Response> v1UsersMeAvatarPut({ MultipartFile body }) async
    test('test v1UsersMeAvatarPut', () async {
      // TODO
    });

    // アカウント削除（論理削除・30 日保持）
    //
    //Future v1UsersMeDelete() async
    test('test v1UsersMeDelete', () async {
      // TODO
    });

    // 自分の情報を取得
    //
    //Future<MeResponse> v1UsersMeGet() async
    test('test v1UsersMeGet', () async {
      // TODO
    });

    // プロフィール編集・バージョン情報更新
    //
    //Future<MeResponse> v1UsersMePatch({ UpdateMeRequest updateMeRequest }) async
    test('test v1UsersMePatch', () async {
      // TODO
    });

    // 初回登録
    //
    // 匿名認証直後に呼び出す。publicId はサーバーで採番する。
    //
    //Future<MeResponse> v1UsersPost({ CreateUserRequest createUserRequest }) async
    test('test v1UsersPost', () async {
      // TODO
    });
  });
}
