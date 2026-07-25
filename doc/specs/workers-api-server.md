# Workers API サーバー仕様

## 責務と境界

Workers API は Firebase Auth で認証された利用者に対し、D1 上の teigiii データと R2 上のアバターを REST API として提供する。HTTP のフィールド・ステータス定義は `backend/openapi.json` を正本とし、本書は認証、認可、可視性、状態遷移、並び順、運用上の振る舞いを定義する。

Firebase Auth、App Check、Analytics、Crashlytics は継続利用する。Workers から Firebase Admin SDK は利用せず、公開鍵による JWT 検証だけを行う。

Flutter repository の接続は #185、Firestore / Firebase Storage の既存データ移行と
初回 prod 切替は #186 で完了している。

## 環境

| 環境 | Worker | Firebase | D1 | R2 | 配信 |
|---|---|---|---|---|---|
| local | `teigiii-api` | `everyone-teigi-dev` | `teigiii-local` | `teigiii-local-avatars` | 認証付き Worker API |
| dev | `teigiii-api-dev` | `everyone-teigi-dev` | `teigiii-dev` | `teigiii-dev-avatars` | 認証付き Worker API |
| prod | `teigiii-api-prod` | `everyone-teigi-prod` | `teigiii-prod` | `teigiii-prod-avatars` | 認証付き Worker API |

Firebase project ID と project number は公開識別子として Wrangler vars に置く。トークン、秘密鍵、Cloudflare API token はコード、設定ファイル、ログへ保存しない。

dev は `just backend-deploy-dev`、prod は `just backend-deploy-prod` で手動デプロイする。
どちらも D1 migration の成功後に Worker を deploy し、自動デプロイ CI は導入しない。

## リクエスト保護

<!-- @code backend/src/auth/middleware.ts#createAppCheckMiddleware -->
<!-- @code backend/src/auth/middleware.ts#createFirebaseAuthMiddleware -->
### 適用順序

1. CORS を適用する（許可 origin の OPTIONS preflight はここで short-circuit）
2. request ID を発行する
3. App Check を検証する
4. `GET /v1/app-config` 以外では Firebase ID トークンを検証する
5. Zod でリクエストを検証する
6. 認可とデータ操作を行う
7. 統一エラーと構造化ログを確定する

認証バイパスは local / dev / prod のいずれにも設けない。単体・結合テストは検証器を依存注入し、実通信テストは dev Firebase が発行した正規トークンを使う。

<!-- @code backend/src/middleware/cors.ts#createCorsMiddleware -->
### CORS（Web QA）

ブラウザからの **dev** Web QA アクセスのため、App Check より前に CORS を適用する。
緩和は binding `WEB_QA_PAGES_PROJECT` が設定されている環境（local / `env.dev`）でのみ有効で、
prod（`env.prod`）にはこの binding を置かず allowlist を空にする。

有効時の許可 origin は次のみ。

- `http://localhost:<port>` / `http://127.0.0.1:<port>`
- LAN IP（`192.168.*` / `10.*` / `172.16-31.*`）
- `https://<WEB_QA_PAGES_PROJECT>.pages.dev` およびそのプレビューサブドメイン
  （例: `https://abc.teigiii-web-dev.pages.dev`）。第三者の `*.pages.dev` は許可しない。

それ以外の Origin には `Access-Control-Allow-Origin` を付けない。CORS はブラウザ向けの緩和であり、認証・App Check の代替ではない。

<!-- @code backend/src/auth/app-check.ts#AppCheckTokenVerifier -->
### App Check

全エンドポイントで `X-Firebase-AppCheck` ヘッダーを必須とする。公式 JWKS `https://firebaseappcheck.googleapis.com/v1/jwks` を使い、以下を検証する。

- 署名
- header の `alg=RS256`、`typ=JWT`、非空 `kid`
- `iss=https://firebaseappcheck.googleapis.com/<project_number>`
- `aud` に `projects/<project_number>` が含まれること
- `exp` が未来であること
- `sub` が非空の App ID であること

`sub` の App ID は認証コンテキストに保持するが、許可リストでは制限しない。limited-use token とリプレイ検知は行わない。

<!-- @code backend/src/auth/firebase-id-token.ts#FirebaseIdTokenVerifier -->
### Firebase ID トークン

`GET /v1/app-config` を除く全エンドポイントで `Authorization: Bearer <token>` を必須とする。以下を検証し、成功時の `sub` をリクエスト利用者の UID とする。

- 署名
- header の `alg=RS256`、非空 `kid`
- `exp` が未来、`iat` が未来でないこと
- `aud=<project_id>`
- `iss=https://securetoken.google.com/<project_id>`
- `sub` が非空文字列であること

トークン失効確認は行わず、最長1時間の自然失効を許容する。

<!-- @code backend/src/auth/firebase-public-keys.ts#FirebasePublicKeyProvider -->
### 公開鍵キャッシュ

Firebase ID トークンの X.509 公開鍵は Google の公式 endpoint から取得する。レスポンスの `Cache-Control: max-age` まで isolate 内でインポート済み CryptoKey を再利用する。ヘッダーが不正または欠落している場合の再取得間隔は5分とする。

未知の `kid` を受け取った場合は、有効期限内でも一度再取得して鍵ローテーションへ追従する。同一 isolate 内の同時取得は1リクエストにまとめる。再取得後も `kid` がなければ401とする。

## 共通処理

<!-- @code backend/src/app.ts#createApp -->
### リクエスト処理順序

Hono app は CORS、request context、App Check、Firebase Auth の順に middleware を適用してから `/v1` ルートを実行する。検証済み UID と App ID はヘッダーやリクエスト body から受け取らず、middleware が設定したコンテキストだけを信頼する。

<!-- @code backend/src/errors.ts#ApiError -->
### エラー形式

全 API エラーは次の形式とする。

```json
{
  "error": {
    "code": "machine_readable_code",
    "message": "利用者向けメッセージ"
  }
}
```

認証失敗は401、入力不正は400、権限不足は403、不可視または不存在のリソースは404、競合は409、画像容量超過は413、画像形式不正は415とする。予期しない例外は500 `internal_error` とし、例外メッセージや stack trace をレスポンスへ含めない。

<!-- @code backend/src/middleware/request-context.ts#createRequestContextMiddleware -->
### リクエスト ID とログ

各リクエストに UUID の request ID を発行し、`X-Request-ID` レスポンスヘッダーへ設定する。リクエストの構造化ログには request ID、method、path、status、処理時間だけを記録する。予期しない例外は相関用の request ID と例外型を別の構造化ログへ記録するが、例外メッセージと stack trace は記録しない。

JWT、Authorization、App Check token、プロフィール内容などの個人情報はログへ出さない。認証失敗は `app_check_invalid` または `firebase_id_token_invalid` としてレスポンスで分類する。

## データ共通規約

- DB 列は snake_case、JSON は camelCase とする
- DB の日時は unix ミリ秒、API は ISO 8601 UTC とする
- 一覧は不透明な keyset cursor を使い、既定20件、最大50件とする
- cursor の形式不正は400とし、別 endpoint や別 sort の cursor は再利用できない
- 論理削除済みのユーザーと定義は、削除した本人を含む通常 API から即時に不可視とする
- D1 の複数行更新は batch など原子的に完了する方法を使う
- いいね、保存、フォロー、ミュートの PUT / DELETE は冪等とする

## API 振る舞い

<!-- @code backend/src/config/app-config-service.ts#AppConfigService -->
### App config

`GET /v1/app-config` は D1 の `app_config` 単一行を返す。Firebase ID トークンは不要だが App Check は必須とする。単一行がなければ500とし、暗黙の既定値では起動を続けない。

運用時の変更は `wrangler d1 execute` で行い、管理 API は追加しない。

<!-- @code backend/src/users/user-service.ts#UserService -->
### ユーザー

- `POST /v1/users` は認証 UID を主キーに初回登録し、9桁数字の publicId を暗号学的乱数で生成する。UNIQUE 競合時は再試行し、同じ UID が登録済みなら409 `user_already_exists` を返す
- 自分の取得・更新は認証 UID だけを対象とし、他者の private 情報を返さない
- 他者プロフィールと一覧は論理削除済みユーザーを除外する
- フォローとミュートは自己指定を400で拒否し、対象が不可視なら404とする
- フォローとミュートの追加・解除は冪等とする。フォロワー・フォロー中一覧は関係作成日時、ユーザー ID の降順で keyset pagination する
- アカウント削除はユーザーと所有する定義へ `deleted_at` を設定し、通常 API から即時に不可視とする

<!-- @code backend/src/users/user-service.ts#AvatarService -->
### アバター

`PUT /v1/users/me/avatar` は JPEG / PNG を受け付け、Content-Type とファイルシグネチャの両方を検証する。10 MiB を安全上限とし、Workers では画像変換しない。

Issue `#185` の Flutter クライアントは HEIC を含む元画像を切り抜き、512 x 512 JPEG quality 85 に変換して送る。R2 key はユーザー単位で固定し、再アップロードは上書きする。削除は R2 object がなくても成功する。

R2 key は `avatars/<URL エンコード済み Firebase UID>` とし、object の HTTP metadata に検証済み Content-Type を保存する。bucket に r2.dev URL または R2 custom domain を設定せず、object は公開しない。

レスポンスの `avatarUrl` は `<AVATAR_BASE_URL>/avatars/<URL エンコード済み Firebase UID>` とする。`AVATAR_BASE_URL` は各環境の Worker API `/v1` URLを指す。`GET /v1/avatars/{id}` は App Check と Firebase ID token に加え、閲覧者と対象ユーザーが論理削除されていないことを検証してから R2 object を返す。応答は保存済み Content-Type、`ETag`、`Cache-Control: private, max-age=300`、`X-Content-Type-Options: nosniff` を設定する。URLだけを知る未認証者には画像を返さない。

#185 の Flutter クライアントは通常 API と同様に画像取得へ `X-Firebase-AppCheck` と `Authorization` ヘッダーを付ける。

<!-- @code backend/src/words/word-service.ts#WordService -->
### 言葉

- 登録前に前後空白を除去し NFC 正規化する。`POST /v1/words` は言葉単体の明示登録専用で、新規は 201、既存への明示登録・公開昇格は 200。重複する言葉は作らず、読みが異なっても既存の読みを採用する
- 新規 ID は UUIDv7、読みグループは正規化済み reading からサーバーが算出する
- 最初の明示登録日時・登録者と、ユーザーごとの `word_registrations` を保持する。同じユーザーの再登録は冪等で、別ユーザーの再登録は最初の登録日時を更新しない
- 公開経路（みんなの辞書・検索・保存一覧・直接取得・タイムラインの言葉登録）は、ミュートしていない明示登録または公開定義がある言葉だけを返す。閲覧権限のない直接取得は 404 `word_not_found`
- 言葉の修正は登録後1時間以内かつ、行の作成者と最初の明示登録者が同一の本人で、他ユーザーの定義または保存がない場合だけ許可する
- 一覧は reading の文字種クラス（五十音 → 英字 → 数字・記号）と reading、id の安定順とし、指定された行、定義有無、検索語を適用する

<!-- @code backend/src/definitions/definition-service.ts#DefinitionService -->
### 定義

- draft は `finalized_at=null`、public / private は初回確定時の `finalized_at` を持つ
- `POST /v1/definitions` は `wordId` または `word` + `reading` のいずれか一方を受け付ける。後者ではサーバーが言葉を解決／必要時に内部作成してから定義を作成する。内部作成は明示登録にしない
- 許可する状態遷移は draft から public / private、public と private の相互切替だけとし、draft へ戻さない
- 確定後1時間を超えた本文編集を403で拒否する。公開範囲の変更では `finalized_at` を更新しない
- 他者は public だけを閲覧でき、本人は自分の draft / private も閲覧できる。不可視な定義は404として存在を秘匿する
- 削除は所有者だけが実行でき、`deleted_at` を設定する
- いいね対象は他者が閲覧可能な public 定義と、自分が閲覧可能な自分の定義に限定する

<!-- @code backend/src/browse/browse-service.ts#BrowseService -->
### 辞書と一覧

- 公開辞書は対象ユーザーの public 定義だけを言葉単位にまとめる
- 本人向け辞書は draft / private を含め、endpoint ごとの status 条件を適用する
- 合成 DTO の likesCount、followingCount、followerCount は有効な行だけを集計する
- `isLikedByMe`、`isFollowedByMe`、`isMutedByMe` は認証 UID を基準に算出する

<!-- @code backend/src/browse/browse-service.ts#BrowseService -->
### タイムラインと検索

- 見つけるは public 定義を `finalized_at DESC`、最初の明示登録を `first_registered_at DESC` として混在させる。任意の `type=definition|wordRegistered` が指定された場合は対応する activity だけを返す
- 言葉登録 activity は最初の明示登録時だけ表示し、再登録では再掲しない。内部作成だけの言葉は言葉登録 activity に出さない
- フォロー中はフォロー対象者の public 定義だけを返す
- タイムラインと検索は認証利用者がミュートしたユーザーを除外する。言葉登録のミュート判定は最初の明示登録者を基準にする
- 言葉検索は公開判定を満たす言葉だけを対象に、表記・よみの部分一致を適用する。ユーザー検索は表示名・publicId の部分一致を適用する
- リアクション数順はページ移動中の件数変動による重複・欠落を許容する

<!-- @code backend/src/maintenance/physical-deletion.ts#runPhysicalDeletion -->
## 物理削除

Scheduled Handler は30日以前に論理削除された定義とユーザーを物理削除する。ユーザー削除では R2 アバターを削除してから D1 ユーザーを削除し、FK CASCADE で関連行と定義を削除する。`words.created_by` と `words.first_registered_by`、`word_registrations.user_id` は SET NULL とし、言葉自体と匿名化された明示登録関係は残す。

期限は Scheduled Event の `scheduledTime - 30日` とし、`deleted_at` が期限と同値の行も対象に含める。定義は一括削除し、ユーザーは R2 削除後に1件ずつ D1 から削除する。R2 またはユーザー D1 削除に失敗した場合は当該ユーザーを D1 に保持して他のユーザーを継続する。定義の一括削除に失敗した場合もユーザー削除は継続する。残った対象は次回実行で再試行するため、処理は冪等である。

完了ログは定義とユーザーごとに `target`、`success`、`failure` を記録する。失敗ログは対象種別、`avatar_delete` / `database_delete` の段階、例外型だけを記録し、UID、R2 key、例外メッセージ、stack trace は含めない。dev では remote bindings を使う scheduled endpoint から手動検証し、prod Cron は #186 で有効化する。

## テストと検証

- 純粋ロジックと SQLite 互換クエリは `bun test`
- Web Crypto、D1、R2、Scheduled Handler は Cloudflare Vitest integration で workerd 上の結合テスト
- OpenAPI 生成物は schema validation とルート集合を検証する
- 主要 D1 クエリは `EXPLAIN QUERY PLAN` で意図した index 利用を確認する
- HEIC から JPEG への変換は #185 で iOS 実機テストする

各 PR で lint、typecheck、format check、全テスト、OpenAPI 差分、DocBridge check を通す。

## 運用

### dev デプロイと smoke test

1. 初回 deploy で確定した `teigiii-api-dev` の workers.dev URL に `/v1` を付け、`backend/wrangler.toml` の dev `AVATAR_BASE_URL` を置き換える。R2 public access は有効化しない。
2. `just backend-deploy-dev` を実行する。このコマンドは D1 migration、`app_config` 初期行の冪等な作成、`teigiii-api-dev` の deploy を順に行う。
3. dev Firebase の正規トークンを shell 環境だけに設定し、次を実行する。トークンをファイル、shell history、ログへ保存しない。

```bash
TEIGIII_API_BASE_URL=https://teigiii-api-dev.tetsuo21ad.workers.dev \
FIREBASE_ID_TOKEN='<dev Firebase ID token>' \
FIREBASE_APP_CHECK_TOKEN='<dev App Check token>' \
just backend-smoke-dev
```

smoke test は app-config、認証、D1 のユーザー作成・更新、非公開 R2 アバターの upload・URL 単独アクセスの401・認証付き取得・delete を確認する。ユーザーが既存なら作成の409を許容し、更新で D1 write を検証する。

Scheduled Handler は次のように remote dev D1 / R2 に対して手動検証する。

```bash
# terminal A
just backend-dev-remote-scheduled

# terminal B
curl 'http://localhost:8787/__scheduled?cron=0+3+*+*+*'
```

30日以前へ backdate した dev 専用 fixture を事前に用意し、HTTP 200、構造化ログの件数、D1 行と R2 object の削除を確認する。本番データを fixture に使わない。Wrangler 4.110 の `--remote --test-scheduled` は互換 endpoint `/__scheduled` を使う。

### prod デプロイ

1. `just backend-validate-prod` で `teigiii-api-prod`、`teigiii-prod`、
   `teigiii-prod-avatars`、prod Firebase vars の bundle / bindings 解決を dry-run する。
2. `just backend-deploy-prod` を実行する。この recipe は
   `backend-migrate-prod` の成功後にだけ prod Worker を deploy する。
3. `wrangler d1 migrations list DB --env prod --remote` で未適用 migration が
   ゼロであることを確認し、prod の主要フローを smoke test する。

R2 public access は有効化しない。Cron は Wrangler 設定を正本とし、UTC の実行時刻を
変更する場合はデプロイ前に確認する。

### 使用量監視と通知

- Workers request / CPU、D1 rows read / written と storage、R2 storage / Class A / Class B operations を各 product の Analytics で確認する。
- Pay-as-you-go account では Cloudflare Dashboard の `Manage Account > Billing > Billable Usage > Create budget alert` から account 全体の USD 閾値と通知先を設定する。
- Professional 以上かつ Pay-as-you-go で product 別通知が利用できる場合は `Notifications > Add > Billable Usage` から Workers / R2 等の閾値を設定する。
- budget alert と usage notification は停止・上限制御ではない。通知後は Billable Usage と product Analytics を確認し、想定外の呼び出し元、Cron 頻度、D1 query、R2 operation を切り分ける。

参考: [Cloudflare Budget alerts](https://developers.cloudflare.com/billing/manage/budget-alerts/)、[Usage-based billing](https://developers.cloudflare.com/billing/understand/usage-based-billing/)、[Cron Triggers](https://developers.cloudflare.com/workers/configuration/cron-triggers/)

Firebase / Cloudflare の秘密情報は Wrangler secrets、GitHub secrets、または実行中の shell 環境だけに置き、リポジトリやログへ保存しない。
