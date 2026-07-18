# Flutter repository 層の REST 繋ぎ替え

## 目的

Issue #185 のフェーズ 4 として、Flutter アプリの repository 層を Firestore / Firebase Storage 依存から Workers REST API（dev 環境デプロイ済み）へ置換する。UI は現状維持とし、挙動変更は台帳で確定済みの例外 4 件のみとする。

- 対応表の正本: `doc/specs/legacy-repository-api-mapping.md`
- API の正本: `server/openapi.json`（41 オペレーション）
- 挙動仕様: `doc/specs/workers-api-server.md`

## スコープ

- OpenAPI からの Dart クライアント自動生成と、生成コマンドの justfile / flake 統合
- Firebase ID トークン + App Check トークンを付与する HTTP クライアント基盤（dev / prod の base URL 切替を含む）
- 台帳に記載された全 repository 操作の REST 置換（対象外・集約・埋め込みを含む）
- アバターアップロードの Firebase Storage → R2 切替（クライアント側で 512 x 512 JPEG quality 85 へ正規化、#184 で決定済み）
- 挙動変更の例外 4 件の実装
  1. 確定済み定義の編集画面で言葉・よみを読み取り専用化
  2. 定義削除時に孤児の言葉を削除しない
  3. AppConfig のリアルタイム監視 → 起動時ポーリング
  4. アカウント削除のクライアント fan-out 廃止（`DELETE /v1/users/me` → Firebase Auth `deleteUser` の 2 手順に集約）
- `cloud_firestore` / `firebase_storage` パッケージ依存の完全除去
- dev Workers に対する実機での総合動作確認

## スコープ外

- UI の見た目・画面構成の変更（#187 の新 UI で実施）
- Firestore / Firebase Storage の既存データ移行、prod デプロイ、一斉切替（#186)
- Firebase Auth / Analytics / Crashlytics / App Check の除去（残すことを戦略で決定済み）
- オフラインキャッシュや楽観更新など、現行に存在しない機能の追加

## 確定した設計

### クライアント生成

- `server/openapi.json` から openapi-generator の `dart-dio` でクライアントを生成する（`serializationLibrary=json_serializable` を指定し built_value を回避）。`openapi-generator-cli` は Nix flake で導入する
- 生成物はコミットし、`just generate-api` で再生成できるようにする。openapi.json 変更時は再生成差分でクライアント側の追従漏れを検出する
- Slice 1 冒頭で生成品質を実物確認する。判定対象は `POST /v1/words` の 409 ボディ（`WordConflictResponse`）、keyset cursor、`ErrorResponse` の共通エラー型。使い物にならない場合のみ Freezed DTO + 手書き薄クライアントへフォールバックする

### base URL 切替

- `dart_defines/dev.json` / `prod.json` に `apiBaseUrl` を追加し、既存の `--dart-define-from-file` 機構で注入する
- dev は配備済み dev Worker（`teigiii-api-dev`）の workers.dev URL を設定する。prod は未デプロイのためプレースホルダとし、#186 で確定する

### dev 実機確認の運用

- dev flavor は `everyone-teigi-dev` に接続済みで、サーバー `env.dev` の検証対象と一致している。テストアカウントは匿名認証で都度作成する
- 非 release ビルドは App Check の debug provider を使うため、実機確認に使う端末・シミュレータの debug token を Firebase console（everyone-teigi-dev）へ登録する（未登録だと全リクエストが 401 になる）

### 認証・共通処理

- dio インターセプタで `Authorization: Bearer <Firebase ID トークン>` と `X-Firebase-AppCheck` を全リクエストに付与する（`GET /v1/app-config` も App Check は必須）
- アバター画像の表示（`GET /v1/avatars/{id}`）も認証ヘッダーが必要なため、認証付き画像取得の仕組みを基盤に含める
- 401 / 404 / 409 など API エラーの共通ハンドリングを定め、既存 UI のエラー表示挙動を維持する

### 置き換え方式

- repository の公開インターフェース（メソッドシグネチャと戻り値の domain 型）を可能な限り維持し、内部実装のみ REST 化する。呼び出し側の変更は「埋め込み」「集約」で呼び出し自体が消えるものと例外 4 件に限定する
- リリースは #186 の一斉切替まで行わない前提で、feature flag は設けず develop 上で直接置換する

## 実行手順

サブ issue 5 件に分割する（#184 と同じスライス運用）。

### Slice 1: API クライアント基盤

1. flake に `openapi-generator-cli` を導入し、`just generate-api` で `server/openapi.json` から dart-dio クライアントを生成する
2. 生成品質（409 ボディ・cursor・共通エラー型）を確認し、フォールバック要否を判断する
3. dio + 認証インターセプタ（ID トークン / App Check）を TDD で実装する
4. `dart_defines` に `apiBaseUrl` を追加し、共通エラーハンドリングを実装する
5. App Check debug token を登録し、dev Workers に対して実機で疎通確認する（`GET /v1/app-config`）

### Slice 2: ユーザー・フォロー・ミュート・R2 アバター

1. `user_profile` / `register_user` / `user_search` / `user_follow` / `user_config`（ミュート）の各 repository を置換する
2. 画像の 512 x 512 JPEG quality 85 正規化と `PUT /v1/users/me/avatar` を実装する
3. 認証付きアバター表示に切り替え、`firebase_storage` 呼び出しを除去する

### Slice 3: 言葉・定義・いいね（書き込み系）

1. `word` / `write_definition` / `fetch_definition` / `like_definition` の各 repository を置換する（言葉重複は 409 の `existingWord.id` を利用）
2. 例外 1: 編集画面の言葉・よみを読み取り専用化する
3. 例外 2: 定義削除時の孤児言葉削除ロジックを除去する

### Slice 4: 一覧系（フィード・辞書・検索）

1. `definition_id_list` / `fetch_word_list` / `fetch_user_list` の各 repository を置換する
2. keyset cursor によるページングへ切り替え、`mutedUserIdList` によるクライアント側フィルタを除去する

### Slice 5: AppConfig・アカウント削除・総仕上げ

1. 例外 3: `app_config_repository` を起動時ポーリングに置換する
2. 例外 4: アカウント削除フローを `DELETE /v1/users/me` + Auth `deleteUser` に集約し、fan-out 処理を削除する
3. `cloud_firestore` / `firebase_storage` を pubspec から除去し、残存参照がないことを確認する
4. dev Workers に対する実機での主要フロー総合確認（登録 → 投稿 → いいね → フォロー → 検索 → 削除）
5. 全検証後に本 plan を `doc/plans/done/` へ移動する

## テスト方針

- repository のテストは mockito で HTTP 層をモックし、Red-Green-Refactor で実装する
- 生成クライアントそのものはテストせず、repository（変換・エラーハンドリング）と認証インターセプタをテスト対象とする
- 各 PR で `just analyze` / `just format` / `just test` を通す
- Slice 5 で dev Workers + dev Firebase の実トークンによる実機確認を行う

## 完了条件

- 台帳の全操作が REST（または対象外・集約・埋め込み）に置換され、`cloud_firestore` / `firebase_storage` 依存が消えている
- 例外 4 件が実装され、それ以外の UI 挙動が現状維持である
- dev Workers に対して実機で主要フローが動作する
- `just analyze` / `just test` が通る
- サブ issue 5 件が完了し、#185 を閉じられる
