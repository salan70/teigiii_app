# Analytics イベントカタログ

Firebase Analytics のイベント名・パラメータ・発火タイミング・call site の正本。

<!-- @code mobile_app/lib/core/analytics/analytics_service.dart#AnalyticsService -->
## 概要

- 画面は `screen_view`（`FirebaseAnalyticsObserver`）
- 重要アクションは**成功のみ**
- 命名: `snake_case` 過去形
- パラメータ: ID + 低カーディナリティ分類のみ。本文・表示名・検索語・URL は送らない。bool は送信時に 1/0 へ正規化
- 差し込みは `AnalyticsService` facade 経由。**application 層からのみ**呼び出し
- ATT 拒否でも行動イベントは送る（Analytics 送信と独立）
- Crashlytics 用 `logger` とは分離

## 規約

| 項目 | 内容 |
|------|------|
| イベント名 | 英数字と `_`、40 文字以内、先頭は英字 |
| トグル系 | 状態別イベント（例: `definition_liked` / `definition_unliked`） |
| 失敗 | 送らない（Crashlytics / API ログ側） |

## Phase 0 — 基盤

| イベント | パラメータ | 発火タイミング | call site |
|----------|------------|----------------|-----------|
| `app_launched` | `flavor` ∈ {`dev`,`prod`} | アプリ起動後（ProviderScope 配下） | `main.dart` / `MyApp` |
| `user_signed_in_anonymously` | （なし） | 匿名サインイン成功後 | `auth_service.dart` → `signIn()` |
| `user_registered` | （なし） | サーバーユーザー登録完了後 | `auth_service.dart` → `_initUser()` |

`setUserId(Auth uid)`: `signIn` / `updateUserConfig` 成功後にセット。`deleteUser` 成功後にクリア。

## Phase 1 — 画面（`screen_view`）

`FirebaseAnalyticsObserver` がルート名を `screen_name` として自動送信。検索語・表示名は送らない。

主なルート: `WelcomeRoute`, `HomeRoute`, `DictionaryIndividualRoute`, `DictionaryEveryoneRoute`, `WordTopRoute`, `DefinitionDetailRoute`, `ProfileTopRoute`, `UserListLikedRoute`, `UserListFollowingOrFollowerRoute`, `UserListMutedRoute`, `UserSearchRoute`, `UserSearchResultRoute`, `SettingRoute`, `DefinitionPostRoute`, `DefinitionEditRoute`, `ProfileEditRoute`, `WordRegistrationRoute`, `WordListRoute`, `WordSearchResultRoute`, `DictionarySubIndexRoute`, `IndividualDictionaryDefinitionListRoute`, `MyLicenseRoute`, `SignInFailureRoute` など。

## Phase 2 — コア行動

| イベント | パラメータ | 発火タイミング | call site |
|----------|------------|----------------|-----------|
| `definition_posted` | `definition_id`, `is_public` | 投稿成功後 | `definition_for_write_notifier.dart` → `post()` |
| `definition_updated` | `definition_id`, `is_public` | 更新成功後 | `definition_for_write_notifier.dart` → `edit()` |
| `definition_deleted` | `definition_id`, `word_id`, `was_public` | 削除成功後 | `definition_service.dart` → `deleteDefinition()` |
| `definition_visibility_changed` | `definition_id`, `word_id`, `is_public`（変更後） | 公開設定変更成功後 | `definition_service.dart` → `updatePostType()` |
| `word_saved` | `word_id` | 保存成功後 | `word_save_controller.dart` → `toggle()` |
| `word_unsaved` | `word_id` | 解除成功後 | 同上 |

### 現行コードに存在しないため対象外

- `definition_draft_saved` / `definition_draft_deleted` — 永続 draft 機能なし
- `word_updated` — `WordRepository.update` なし

## Phase 3 — ソーシャル

| イベント | パラメータ | 発火タイミング | call site |
|----------|------------|----------------|-----------|
| `definition_liked` | `definition_id`, `word_id`, `author_id` | いいね成功後 | `like_definition_service.dart` → `tapLike()` |
| `definition_unliked` | 同上 | いいね解除成功後 | 同上 |
| `user_followed` | `target_user_id` | フォロー成功後 | `user_follow_service.dart` → `follow()` |
| `user_unfollowed` | `target_user_id` | 解除成功後 | `user_follow_service.dart` → `unfollow()` |
| `user_muted` | `target_user_id` | ミュート成功後 | `user_config_service.dart` → `muteUser()` |
| `user_unmuted` | `target_user_id` | 解除成功後 | `user_config_service.dart` → `unmuteUser()` |

## Phase 4 — その他

| イベント | パラメータ | 発火タイミング | call site |
|----------|------------|----------------|-----------|
| `policy_agreed` | （なし） | 初回同意保存成功後 | `introduction_service.dart` → `onAgreePolicy()` |
| `tracking_authorization_completed` | `status`（ATT enum 名） | ATT 状態確定後 | 同上 |
| `profile_updated` | `changed_name`, `changed_bio`, `changed_avatar`（bool） | プロフィール更新成功後 | `user_profile_for_write_notifier.dart` → `edit()` |
| `account_deleted` | （なし） | アカウント削除成功後 | `auth_service.dart` → `deleteUser()` |
| `force_update_shown` | （なし） | 強制アップデート判定が true | `app_config_state.dart` → `isRequiredAppUpdate` |
| `maintenance_shown` | （なし） | メンテナンス中フラグが true | `app_config_state.dart` → `appConfig` |
| `external_link_opened` | `link_type` ∈ {`how_to`,`inquiry`,`terms`,`privacy`,`store_listing`,`force_update_store`} | URL 起動成功後 | `launch_url_controller.dart` → `launchURL()` |

`link_type` は URL 定数から推定する。ストア URL は呼び出し元が `force_update_store` を明示しない限り `store_listing`。

## 非対象

- AdMob カスタム成功イベント
- 起動時バックグラウンドの `updateUserConfig`（ユーザー操作ではない）への行動イベント
- User Properties
- 開始 / 失敗イベント
- ATT 拒否時の Analytics 無効化
- Firebase Performance Monitoring
