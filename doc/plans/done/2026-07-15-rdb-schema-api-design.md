# RDB スキーマ + API 設計（Drizzle / OpenAPI）

> 注記: ディレクトリ再編（#230）に伴うパス・コマンド表記の書き換えは行っていない。完了時点の記録を保持する。現行構成のパスは `mobile_app/` / `backend/` を参照。

issue #183（Cloudflare 移行 2/6）の実行計画。grilling による設計判断の確定記録を含む。

- 戦略: `doc/plans/2026-07-12-cloudflare-migration-strategy.md`
- 情報設計: `doc/specs/new-ui-information-architecture.md`

## 目的

新 UI の情報設計（Tier 1 スコープ）を満たし、かつ旧 UI がその部分集合で動作する Drizzle スキーマと OpenAPI 定義を、`server/` 配下の実コードとして作成する。

## 成果物の形（確定）

- **実コード方式**: `server/` に動く Drizzle スキーマ（`schema.ts`）+ `@hono/zod-openapi` のルート定義を書く。ハンドラは未実装スタブ
- `drizzle-kit generate` で SQL マイグレーションが出せる状態にする
- ルート定義から `openapi.json` を生成するスクリプトを用意し、**生成物もコミット**する（フェーズ 4 の Dart クライアント生成が server のビルド環境なしで動く）
- 実ハンドラ・テスト本体・dev/prod 環境分離・デプロイ設定はフェーズ 3（#184）のスコープ

## スキーマ設計（確定）

### テーブル一覧

`users` / `words` / `definitions` / `likes` / `follows` / `user_mutes` / `saved_words` / `app_config` の 8 テーブル。Tier 2 機能（リアクション 3 種化・通知・定義リクエスト・ブロック等）は事前にテーブル化しない。

### ID 戦略

- `words` / `definitions` は TEXT PK。**既存レコードは Firestore の 20 文字 ID をそのまま移行**し、新規レコードはサーバー生成の UUIDv7
  - 移行スクリプトが ID 変換表を持たずに済み、FK が無加工で成立する。ID 保存方式は UPSERT による冪等な再実行とも相性が良い
- `users.id` は Firebase Auth の UID をそのまま使う（戦略で決定済み）
- `likes` / `follows` / `user_mutes` / `saved_words` は複合 PK で個別 ID なし
- 日時列は INTEGER（unix ミリ秒）で持ち、API 境界で ISO 8601 に変換する

### users

現行の `UserProfiles` / `UserConfigs` / `UserFollowCounts` の 3 コレクションを単一テーブルに統合する。

| 列 | 型・制約 | 備考 |
|---|---|---|
| id | TEXT PK | Firebase UID |
| public_id | TEXT UNIQUE NOT NULL | ユーザー検索用 ID |
| name / bio | TEXT NOT NULL | |
| avatar_key | TEXT NULL | **R2 オブジェクトキーを保存**し、API レスポンス側で完全 URL に解決する。配信ドメイン変更が環境変数 1 個で済む。未設定は NULL |
| last_os_version / last_app_version | TEXT | 現行の UserConfigs.osVersion / appVersion のパリティ。サポート時に SQL で引ける価値を残す |
| created_at / updated_at | INTEGER NOT NULL | |
| deleted_at | INTEGER NULL | アカウント論理削除（30 日保持） |

- `UserFollowCounts` は廃止し `follows` の COUNT で代替
- **起動履歴は持たない**: DAU・リテンション等の集計は残留決定済みの Firebase Analytics が担う。`last_active_at` も現時点の用途がないため追加しない（必要になったら列 1 本のマイグレーションで足りる）

### words

| 列 | 型・制約 | 備考 |
|---|---|---|
| id | TEXT PK | |
| word | TEXT UNIQUE NOT NULL | 表記・30 文字。**UNIQUE 制約を張る**（情報設計 §16.1「同じ表記は同じ言葉」のスキーマレベル強制）。一意性判定は完全一致（前後トリム + NFC 正規化をサーバーで適用。大文字小文字・全角半角は区別） |
| reading | TEXT NOT NULL | よみ・50 文字・かな等のみ（漢字不可、現行バリデーション踏襲） |
| reading_sub_group | TEXT NOT NULL | あかさたな行ラベル。「ゃ→や」「が→か」等の行判定は SQL で書けないため、書き込み時にサーバーで算出して列に持つ（現行 initialSubGroupLabel と同方式）。読み順ブラウジング用にインデックス |
| created_by | TEXT NULL FK→users.id | 登録者。**内部記録のみで API レスポンスに含めない**。ユーザー削除時 SET NULL |
| created_at / updated_at | INTEGER NOT NULL | |

- `deleted_at` なし: 言葉はユーザー削除不可のグローバル資産
- 移行時の帰結: 既存データの同一表記重複はフェーズ 5 の移行スクリプトでマージする（同一表記の word をグルーピングして最古を残し、definitions を付け替え）
- 作成者修正（1 時間以内 + 他ユーザーの定義投稿・保存なし）の判定は既存列 + クエリで行い、専用列は持たない

### definitions

| 列 | 型・制約 | 備考 |
|---|---|---|
| id | TEXT PK | |
| word_id | TEXT NOT NULL FK→words.id | 確定後は変更不可・下書き中は変更可（アプリ層で検証） |
| author_id | TEXT NOT NULL FK→users.id | |
| body | TEXT NOT NULL | 500 文字。完全に空の下書きは作成しない |
| status | TEXT NOT NULL CHECK IN ('draft','public','private') | |
| finalized_at | INTEGER NULL | 初めて public/private で確定した時刻。編集期限 = finalized_at + 1h は**サーバー側で毎回計算し列に持たない**。CHECK で不変条件を強制: `(status = 'draft') = (finalized_at IS NULL)`。移行時の帰結: 既存の public/private 定義には finalized_at のバックフィルが必須（現行に確定時刻がないため createdAt を充てる） |
| is_edited | INTEGER NOT NULL DEFAULT 0 | **「確定後に本文を編集した」場合のみ true**。下書き中の編集・公開/非公開切り替えでは立てない（現行の一律 isEdited より意味を限定） |
| deleted_at | INTEGER NULL | 論理削除（30 日保持） |
| created_at / updated_at | INTEGER NOT NULL | |

- 現行の非正規化フィールド（word / wordReading / likesCount 埋め込み）と `WordDefinitionRelations` は廃止し、JOIN / COUNT で置き換え
- タイムライン「見つける」の掲載順は `finalized_at` 降順。非公開→公開へ後から切り替えた定義は確定時刻の位置に置かれ、フィード先頭には出ない（情報設計 §6.2「公開範囲の切り替えは活動として表示しない」と整合）

#### 旧 UI 互換の例外（フェーズ 4 への申し送り）

現行 UI は確定済み定義の言葉変更（`write_definition_repository.dart` の `updateWordChangedDefinition`）と、参照がなくなった言葉の削除（`_needDeleteWord`）を行うが、新スキーマはどちらも許可しない。互換 API は作らず、次のとおり扱う。

- **フェーズ 4 で旧 UI の編集画面の「言葉・よみ」を読み取り専用にする**（本文と公開設定のみ編集可）。戦略「フェーズ 4 では UI を変更しない」に対する明示的な例外 1 件とする。互換 API（確定後の word 変更 + 孤児削除）は UNIQUE 制約・登録者記録・タイムラインと衝突する複雑さを 2 フェーズのためだけに背負うため採らない
- 孤児になった言葉（定義 0 件）は削除せず残す。新モデルでは定義 0 件の言葉は正当な状態（みんなの辞書の「定義なし」絞り込み対象）

### 関係テーブル

```text
likes        (user_id, definition_id, created_at)   PK(user_id, definition_id)
follows      (follower_id, following_id, created_at) PK(follower_id, following_id)
user_mutes   (muter_id, muted_user_id, created_at)  PK(muter_id, muted_user_id)
saved_words  (user_id, word_id, created_at)         PK(user_id, word_id)
```

- リアクションは `likes` 固定で作る。Tier 2 の 3 種化は「reaction_type 列追加（既存行 'like' バックフィル）+ PK 張り直し」のマイグレーションで対応し、事前に汎用化しない

### FK・CHECK 制約（削除の連鎖）

30 日後の物理削除バッチ（実装はフェーズ 3 以降）が安全に書けるよう、削除動作をスキーマで確定する。

- 関係テーブル（`likes` / `follows` / `user_mutes` / `saved_words`）の FK はすべて **ON DELETE CASCADE**（ユーザー・定義の物理削除時に連鎖削除）
- `definitions.author_id` → users も CASCADE(アカウント物理削除で定義も物理削除。情報設計 §19 のとおり匿名化残置はしない)
- `words.created_by` → users のみ **ON DELETE SET NULL**（言葉はグローバル資産として残す）
- `follows` / `user_mutes` に自己参照禁止の CHECK（`follower_id != following_id` 等）
- 全 FK・複合 PK の列は NOT NULL

### インデックス方針

合成 DTO（likesCount / isLikedByMe / フォロー数等）をサブクエリで 1 クエリに畳む前提で、主要一覧クエリごとに複合インデックスを張る。

| クエリ | インデックス |
|---|---|
| タイムライン見つける / フォロー中 | `definitions(status, finalized_at DESC, id)`（deleted_at IS NULL の部分インデックス） |
| 言葉ページの定義一覧 | `definitions(word_id, status, finalized_at DESC)` |
| 自分の定義・下書き一覧 | `definitions(author_id, status, updated_at DESC)` |
| 読み順一覧・行絞り込み | `words(reading_sub_group, reading, id)` |
| 言葉登録の新着（見つけるフィード） | `words(created_at DESC, id)` |
| いいね集計・いいねユーザー一覧 | `likes(definition_id, created_at)`（PK と別途） |
| いいねした定義一覧 | `likes(user_id, created_at DESC, definition_id)` |
| フォロワー逆引き | `follows(following_id, created_at)`（PK と別途） |
| 保存した言葉 | PK(user_id, word_id) + `created_at` 降順は少件数のため追加不要 |

- リアクション数順ソートの keyset カーソルは、ページ移動中に件数が変動した場合の**重複・欠落を許容**する（完全性が必要な一覧ではない）。最終的なインデックス構成は `EXPLAIN QUERY PLAN` で確認して確定する

### app_config

単一行テーブル。強制アップデートとメンテナンスモードを持つ。big-bang 切替の要（旧版強制停止）のため今スキーマに含める。運用時の書き換えは `wrangler d1 execute`。

| 列 | 型・制約 |
|---|---|
| id | INTEGER PK CHECK(id = 1) … 単一行を保証 |
| min_app_version_ios / min_app_version_android | TEXT NOT NULL |
| in_maintenance | INTEGER NOT NULL DEFAULT 0 |
| maintenance_scheduled_end_time | INTEGER NULL … メンテ中のみ設定 |
| updated_at | INTEGER NOT NULL |

レスポンス DTO も同項目（camelCase・日時は ISO 8601）で定義する。

### 通報

現行は外部 Google フォームであり、Tier 1 は「現行の通報相当で代替」のため **reports テーブル / API は作らない**。

## API 設計（確定）

### 表現規約

1. パスは `/v1` プレフィックス
2. JSON フィールドは camelCase（DB 列は snake_case、境界で Drizzle が変換）
3. 日時は ISO 8601 UTC 文字列（OpenAPI `format: date-time`）
4. エラーは統一形式 `{ "error": { "code": "...", "message": "..." } }` + HTTP ステータス。`code` は機械判定用（重複語 409・編集期限切れ 403 等）

### 横断方針

- **ページネーションは keyset カーソル方式で統一**: レスポンスに不透明カーソル（ソートキー + ID を base64）を含め `?cursor=&limit=` で辿る。OFFSET は使わない（挿入時のページ欠落防止・D1 の読み行数課金対策）
- **合成 DTO 方式**: 定義系レスポンスは word / author / likesCount / isLikedByMe を埋め込んで返す。ユーザー系も followingCount / followerCount / isFollowedByMe / isMutedByMe を埋め込む。旧 UI の前提（非正規化データ）と一致し、フェーズ 4 の繋ぎ替えが素直な置換になる
- 下書き自動保存は通常の POST + PATCH。POST 応答喪失による稀な下書き重複は許容（情報設計 §4.3 の割り切りと整合）。クライアント生成 ID の upsert は採らない
- 状態遷移は専用エンドポイントを設けず `PATCH` の `status` 変更で行い、許可される遷移（draft→public/private、public↔private のみ・下書き戻し不可・期限後の本文変更拒否）をサーバーで検証
- 検索は LIKE 部分一致（言葉・ユーザーの規模なら D1 フルスキャンで問題なし）
- 「見つける」は異種アイテム混在フィード。`type: "definition" | "wordRegistered"` の oneOf に **discriminator を明示**（Dart 生成器の互換確保。生成器選定はフェーズ 4）
- ミュートの反映（タイムライン・検索からの除外）はサーバー側クエリで行う
- 認証と App Check は適用範囲を分ける:

| 検証 | 適用範囲 |
|---|---|
| App Check（`X-Firebase-AppCheck`） | **全エンドポイント必須**（app-config 含む。App Check は認証と独立に検証できるため免除の理由がない） |
| Firebase ID トークン | `GET /v1/app-config` のみ免除、他は必須 |

### エンドポイント一覧

```text
認証不要:
  GET    /v1/app-config

ユーザー:
  POST   /v1/users                     初回登録（publicId 採番含む）
  GET    /v1/users/me                  自分（設定含む）
  PATCH  /v1/users/me                  プロフィール編集・バージョン情報更新
  PUT    /v1/users/me/avatar           アバター画像アップロード（バイナリ直接、Workers 経由で R2 へ。署名付き URL 方式はアバター 1 枚の規模では過剰）
  DELETE /v1/users/me/avatar           アバター画像削除
  DELETE /v1/users/me                  アカウント削除（論理。R2 上の画像の物理削除は 30 日後バッチのスコープ）
  GET    /v1/users/{id}                公開プロフィール（合成 DTO）
  GET    /v1/users/{id}/dictionary     公開辞書（言葉単位グルーピング）
  GET    /v1/users/{id}/definitions    ユーザーの定義一覧（本人は非公開含む。?wordId= / ?subGroup= で絞り込み、?sort=newest|reading。旧 UI のプロフィール定義一覧・頭文字別辞書のパリティ）
  GET    /v1/users/{id}/liked-definitions  いいねした定義一覧（他者の公開定義 + 閲覧者自身の定義は非公開でも含む。旧 UI のプロフィール「いいね」タブのパリティ）
  GET    /v1/users/{id}/followers      フォロワー一覧
  GET    /v1/users/{id}/following      フォロー中一覧
  PUT/DELETE /v1/users/{id}/follow     フォロー / 解除
  PUT/DELETE /v1/users/{id}/mute       ミュート / 解除
  GET    /v1/me/mutes                  ミュート中一覧

あなたの辞書:
  GET    /v1/me/dictionary/overview    概要（各件数 + 最近の定義。画面特化の合成 1 本を許容）
  GET    /v1/me/defined-words          定義済み言葉一覧（言葉単位 + 状態別件数）
  GET    /v1/me/definitions?status=draft  下書き一覧
  GET    /v1/me/saved-words            保存した言葉
  PUT/DELETE /v1/words/{id}/save       保存 / 解除

言葉:
  POST   /v1/words                     登録（重複時 409 + 既存言葉返却）
  GET    /v1/words                     読み順一覧（?subGroup= / ?filter=all|defined|undefined / ?q=）
  GET    /v1/words/{id}                言葉ページヘッダ（定義数・保存済みか等）
  PATCH  /v1/words/{id}                作成者修正（1h 以内 + 他ユーザー操作なし、をサーバーで検証）
  GET    /v1/words/{id}/definitions?scope=mine|others|all&sort=newest|reactions
                                       scope=all は自分 + 他者の公開定義の混在（旧 UI の言葉トップのパリティ）

定義:
  POST   /v1/definitions               作成（draft / public / private いずれでも）
  GET    /v1/definitions/{id}          詳細
  PATCH  /v1/definitions/{id}          本文編集・状態遷移（サーバーで期限/遷移検証）
  DELETE /v1/definitions/{id}          削除（論理）
  PUT/DELETE /v1/definitions/{id}/like いいね / 解除
  GET    /v1/definitions/{id}/likes    いいねしたユーザー一覧

タイムライン・検索:
  GET    /v1/timeline/discover         見つける（公開定義 + 言葉登録の混在フィード）
  GET    /v1/timeline/following        フォロー中（公開定義のみ）
  GET    /v1/search/words?q=
  GET    /v1/search/users?q=
```

## ツールチェーン（確定）

docbridge（`salan70/docbridge`）の構成に寄せる。

| 要素 | 決定 | 備考 |
|---|---|---|
| PM / スクリプト実行 | bun | wrangler・drizzle-kit・Hono は bun 配下で動く。デプロイ物は wrangler がバンドルし実行環境は workerd |
| tsconfig | docbridge 同等の strict 設定 | `strict` + `noUncheckedIndexedAccess` + `exactOptionalPropertyTypes`。`types` のみ `@cloudflare/workers-types`（実行環境が workerd のため docbridge と意図的に変える） |
| Lint | oxlint（`.oxlintrc.json`） | 1.0 GA 済み。型起因の検出は strict tsc が担う |
| Format | oxfmt | Prettier JS/TS 準拠テスト 100% パス。不都合が出た場合の退路は Biome（Prettier 互換のため差分ほぼゼロ） |
| テスト | `bun test` | D1 依存のクエリテストは Drizzle の bun:sqlite ドライバでローカル SQLite に対して実行。workerd 固有の検証が必要になった時点で vitest-pool-workers をその部分にだけ追加する（今は二重基盤を持たない） |
| タスク | ルート justfile に server 系レシピ追加 | `server-lint`（oxlint + tsc --noEmit）/ `server-format`（oxfmt）/ `server-generate`（openapi.json + マイグレーション生成）等 |
| wrangler.toml | ローカルで動く最小限 | dev/prod 分離はフェーズ 3 |

## 実行手順

1. `server/` の足場を作る: bun init、依存導入（hono / @hono/zod-openapi / drizzle-orm / drizzle-kit / wrangler / @cloudflare/workers-types / oxlint / oxfmt）、strict tsconfig、`.oxlintrc.json`、最小 wrangler.toml
2. Drizzle スキーマ（8 テーブル + インデックス）を書き、`drizzle-kit generate` で初期マイグレーション SQL を生成する
3. zod スキーマ（リクエスト / レスポンス DTO・エラー形式・カーソル）を定義する
4. `@hono/zod-openapi` でエンドポイント一覧の全ルートを定義する（ハンドラは 501 相当のスタブ）
5. `openapi.json` 生成スクリプトを書き、生成物をコミットする
6. 旧 repository 操作 ↔ 新 API の対応表を作成する（フェーズ 4 の繋ぎ替え台帳。「言葉編集の読み取り専用化」等の例外方針も記載）
7. ルート justfile に server 系レシピを追加する
8. lint / format / tsc / `bun test`（セットアップ確認の最小テスト）を通す

## 完了条件

- `server/` がコンパイル可能（`tsc --noEmit` パス）で、oxlint / oxfmt が通る
- `drizzle-kit generate` が確定スキーマどおりの SQL マイグレーションを出力し、**生成 SQL に UNIQUE / FK（ON DELETE 動作含む）/ CHECK / インデックスが含まれることを確認**している
- エンドポイント一覧の全ルートが OpenAPI 定義に含まれ、`openapi.json` が生成・コミットされ、**OpenAPI スキーマとして検証（validate）が通る**
- **旧 repository 操作 ↔ 新 API の対応表**を作成し、旧 UI の全操作に対応先（または「読み取り専用化」等の例外方針）があることを確認している
- 実ハンドラ・テスト本体・デプロイ設定は含まれていない（フェーズ 3 のスコープ境界を守る）
