# 旧 repository 操作 ↔ 新 API 対応表

issue #183 の成果物。フェーズ 4（Flutter repository 層の繋ぎ替え）の台帳として、旧 UI の全 repository 操作に新 API の対応先（または例外方針）を記録する。

- API 定義の正本: `backend/openapi.json`（`backend/src/routes/` から生成）
- 設計判断: `doc/plans/done/2026-07-15-rdb-schema-api-design.md`

## 凡例

- **API**: 対応する新 API エンドポイント
- **埋め込み**: 個別呼び出しを廃止し、合成 DTO のフィールドで代替
- **集約**: サーバー側処理に集約され、クライアント側の呼び出し自体が消える
- **例外**: 挙動変更を伴う（理由を明記）
- **対象外**: API と無関係（ローカル処理・Firebase Auth）

## 認証・設定

| 旧操作 | 対応 |
|---|---|
| `auth_repository.userChanges` / `signInAnonymously` / `signOut` | **対象外**: Firebase Auth は残す（戦略で決定済み） |
| `auth_repository.deleteUser` | Firebase Auth 側の削除はそのまま + `DELETE /v1/users/me`（下記「アカウント削除」参照） |
| `register_user_repository.initUser` | `POST /v1/users`。publicId の採番・重複確認はサーバーへ移動 |
| `register_user_repository.updateVersionInfo` | `PATCH /v1/users/me` |
| `app_config_repository.subscribeAppConfig` | `GET /v1/app-config`。**例外**: リアルタイム監視 → 起動時ポーリング（戦略で決定済み） |
| `is_first_launch_repository` / `package_info_repository` / `device_info_repository` | **対象外**: ローカル処理 |

<!-- @code mobile_app/lib/feature/definition/repository/fetch_definition_repository.dart#FetchDefinitionRepository -->
<!-- @code mobile_app/lib/feature/definition/repository/write_definition_repository.dart#WriteDefinitionRepository -->
## 定義の読み書き

| 旧操作 | 対応 |
|---|---|
| `fetch_definition_repository.fetchDefinition` | `GET /v1/definitions/{id}` |
| `fetch_definition_repository.fetchAllPostedDefinitionDocList` | **集約**: アカウント削除フローの一部。`DELETE /v1/users/me` に集約 |
| `write_definition_repository.createDefinition` | `POST /v1/definitions` |
| `write_definition_repository.createDefinitionAndWord` | `POST /v1/words` → `POST /v1/definitions` の 2 段。言葉が既存なら 409 レスポンスの `existingWord.id` を使う |
| `write_definition_repository.updateDefinition` | `PATCH /v1/definitions/{id}` |
| `write_definition_repository.updateWordChangedDefinition` / `updateDefinitionAndCreateWord` | **例外**: 確定後の言葉変更は新モデルで廃止（情報設計 §8.4）。フェーズ 4 で編集画面の言葉・よみを読み取り専用にする |
| `write_definition_repository.deleteDefinition` | `DELETE /v1/definitions/{id}`。**例外**: 孤児になった言葉の削除は行わない（言葉はグローバル資産として残す） |
| `write_definition_repository.updatePostType` | `PATCH /v1/definitions/{id}`（`status` の変更） |

<!-- @code mobile_app/lib/feature/definition_like/repository/like_definition_repository.dart#LikeDefinitionRepository -->
## いいね

| 旧操作 | 対応 |
|---|---|
| `like_definition_repository.likeDefinition` | `PUT /v1/definitions/{id}/like` |
| `like_definition_repository.unlikeDefinition` | `DELETE /v1/definitions/{id}/like` |
| `like_definition_repository.isLikedByUser` | **埋め込み**: `DefinitionResponse.isLikedByMe` |
| `like_definition_repository.fetchAllLikedDefinitionIdList` / `deleteLikeByDefinitionId` | **集約**: アカウント削除のクライアント側 fan-out。`DELETE /v1/users/me` に集約 |

<!-- @code mobile_app/lib/feature/definition_list/repository/definition_id_list_repository.dart#DefinitionIdListRepository -->
## 定義一覧（フィード）

| 旧操作 | 対応 |
|---|---|
| `definition_id_list_repository.fetchForHomeRecommend` | `GET /v1/timeline/discover?type=definition`。**例外**: 公開定義のみとし、自分の非公開定義は表示しない。定義だけにサーバー側で絞り込んだ1ページずつ取得する |
| `definition_id_list_repository.fetchForHomeFollowing` | `GET /v1/timeline/following`。**例外**: フォロー中ユーザーの公開定義のみとし、自分の定義と非公開定義は表示しない |
| `definition_id_list_repository.fetchForWordMine` | `GET /v1/words/{id}/definitions?scope=mine&sort=newest`。自分の確定済み定義だけを取得する |
| `definition_id_list_repository.fetchForWordOthers`（createdAt / likesCount 順） | `GET /v1/words/{id}/definitions?scope=others&sort=newest\|reactions`。他者の公開定義だけを取得する |
| `definition_id_list_repository.fetchForProfileCreatedAt` | `GET /v1/users/{id}/definitions` |
| `definition_id_list_repository.fetchForLikedByUser` | `GET /v1/users/{id}/liked-definitions`（他者の公開定義 + 閲覧者自身の定義は非公開でも含む。ミュートした著者の定義は Workers 側で除外） |
| `definition_id_list_repository.fetchForIndividualDictionary` | `GET /v1/users/{id}/definitions?subGroup=&sort=reading`（旧実装と同じ、よみ昇順） |
| 各メソッドの `mutedUserIdList` 引数によるクライアント側フィルタ | **集約**: ミュート除外はサーバー側クエリで実施 |

<!-- @code mobile_app/lib/feature/word/repository/word_repository.dart#WordRepository -->
<!-- @code mobile_app/lib/feature/word_list/repository/fetch_word_list_repository.dart#FetchWordListRepository -->
## 言葉

| 旧操作 | 対応 |
|---|---|
| `word_repository.fetchWordById` | `GET /v1/words/{id}` |
| `word_repository.save` / `unsave` | `PUT /v1/words/{id}/save` / `DELETE /v1/words/{id}/save`。取得時の `isSavedByMe` を初期状態とする |
| `word_repository.create` | `POST /v1/words`。409 の `existingWord` は既存語への導線として表示する |
| `word_repository.update` | `PATCH /v1/words/{id}`。API の `isEditableByMe` が true の場合だけ表記・よみを修正する |
| `word_repository.findWordId` | **集約**: 登録フローは `POST /v1/words` の 409 応答で既存判定。検索は `GET /v1/search/words?q=` |
| `fetch_word_list_repository.fetchWordListStateByInitial` | `GET /v1/words?subGroup=`。**例外**: 公開定義 0 件の言葉も表示する |
| `fetch_word_list_repository.fetchCommunityWordList` | `GET /v1/words?filter=&q=&cursor=`。みんなの辞書の読み順連続一覧、定義有無絞り込み、画面内検索を同一カーソルで取得する |
| `fetch_word_list_repository.fetchWordListStateBySearchWord` | `GET /v1/search/words?q=`。**例外**: 言葉の前方一致から、言葉またはよみの部分一致へ変更する |
| `fetch_word_list_repository.fetchPostedDefinitionCount` | **埋め込み**: `WordListItem.publicDefinitionCount`。ミュートした著者の定義は件数と defined / undefined 判定の両方から Workers 側で除外する |

<!-- @code mobile_app/lib/feature/user_list/repository/fetch_user_list_repository.dart#FetchUserListRepository -->
## ユーザー・フォロー・ミュート

| 旧操作 | 対応 |
|---|---|
| `user_profile_repository.fetchUserProfile` | `GET /v1/users/{id}`（自分は `GET /v1/users/me`） |
| `user_profile_repository.updateUserProfile` | `PATCH /v1/users/me` |
| `storage_repository.uploadFile` | `PUT /v1/users/me/avatar` |
| `storage_repository.deleteFile` | `DELETE /v1/users/me/avatar` |
| `image_repository.pickImage` / `cropImage` | **対象外**: ローカル処理 |
| `user_search_repository.searchByPublicId` | `GET /v1/search/users?q=` |
| `user_follow_repository.follow` / `unfollow` | `PUT` / `DELETE /v1/users/{id}/follow` |
| `user_follow_repository.isFollowing` | **埋め込み**: `UserResponse.isFollowedByMe` / `UserListItem.isFollowedByMe` |
| `user_follow_repository.fetchUserFollowCount` | **埋め込み**: `UserResponse.followingCount` / `followerCount`（UserFollowCounts テーブルは廃止） |
| `user_follow_repository.fetchAllFollowingIdList` | **集約**: フォロー中フィードのサーバー側 JOIN で不要化 |
| `fetch_user_list_repository.fetchFollowingIdList` / `fetchFollowerIdList` | `GET /v1/users/{id}/following` / `followers` |
| `fetch_user_list_repository.fetchLikedUserIdList` | `GET /v1/definitions/{id}/likes` |
| `user_config_repository.fetchUserConfig`（ミュートリスト） | `GET /v1/me/mutes` |
| `user_config_repository.appendMutedUserIdList` / `removeMutedUserIdList` | `PUT` / `DELETE /v1/users/{id}/mute` |

## アカウント削除

旧実装は auth_service がクライアント側で fan-out（全いいね解除 → 全フォロワーからの解除 → プロフィール・設定・フォロー数の削除 → Storage 削除 → Auth 削除）していた。

新実装では `DELETE /v1/users/me` 1 本に集約し、サーバー側で論理削除（30 日保持）する。クライアントに残るのは `DELETE /v1/users/me` → Firebase Auth の `deleteUser` の 2 手順のみ。以下は**すべて廃止**:

- `unlikeAllLikedDefinition` / `unfollowByAllFollower` 等の fan-out 処理
- `deleteUserConfig` / `deleteUserProfile` / `deleteUserFollowCount` / `storage_repository.deleteFile` の個別削除呼び出し

<!-- @code mobile_app/lib/feature/definition/presentation/write_definition_base_page.dart#WriteDefinitionBasePage -->
## フェーズ 4 の挙動変更（例外）まとめ

1. **確定済み定義の言葉変更を廃止**: 編集画面の言葉・よみを読み取り専用化（本文と公開設定のみ編集可）
2. **孤児の言葉を削除しない**: 定義 0 件の言葉は正当な状態として残る
3. **AppConfig のリアルタイム監視 → 起動時ポーリング**
4. **アカウント削除の fan-out がサーバー集約**になり、削除は論理削除（30 日保持）に変わる
5. **デフォルトアイコンの登録時ランダム保存を廃止**: 新 API に「デフォルトアイコン URL を保存する」概念がなく、アバター未設定は `avatarUrl: null` で表現される。クライアントは null のとき同梱 asset 3 種から `hash(userId)` で決定的に 1 種を表示する。既存ユーザーのアイコンを変えないため、#186 のデータ移行で `profileImageUrl` がデフォルト URL 3 種のいずれかに一致するユーザーはその PNG を R2 へアバターとしてコピーする
6. **フィードの公開定義化**: おすすめから自分の非公開定義、フォロー中から自分の定義とフォロー中ユーザーの非公開定義を除外する
7. **公開定義 0 件の言葉も表示**: みんなの辞書は API の言葉一覧をそのまま表示する
8. **言葉検索の拡張**: 言葉の前方一致から、言葉またはよみの部分一致に変更する
