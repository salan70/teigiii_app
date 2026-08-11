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

dev は develop への push で CI から自動デプロイする（`ci.yml` の `deploy-dev` ジョブが
`backend-analyze` / `backend-test` の成功後に `just backend-deploy-dev` を実行する）。
dev Worker が develop と一致していることは web preview の前提条件であり、手動デプロイで
漂流させない。dev の D1 migration は deploy と同じ recipe で一括適用する。

prod は CI からデプロイせず、`just backend-deploy-prod` でローカルから手動デプロイする。
prod 全権の Cloudflare API token を GitHub に置かないため。作業ツリーの内容がそのまま
prod に出る事故は `backend-guard-prod`（作業ツリー clean / `origin/develop` と一致 /
その commit の `ci-passed` が green）で防ぐ。

**prod の D1 migration は deploy の依存に含めない。** deploy は `wrangler rollback` で
可逆だが migration は forward-only で不可逆であり、さらに正しい順序が migration の性質で
反転する（additive なら migrate → deploy、destructive なら deploy → migrate）。
`backend-migrate-prod` / `backend-migrate-prod-telemetry` は個別に実行し、順序は
その migration の性質に応じて判断する。migration の性質とは別に、Worker deploy が
**配信済みアプリを壊さないか**も判断軸になる（「prod デプロイ」節を参照）。

## リクエスト保護

<!-- @code backend/src/auth/middleware.ts#createAppCheckMiddleware -->
<!-- @code backend/src/auth/middleware.ts#createFirebaseAuthMiddleware -->
### 適用順序

1. CORS を適用する（許可 origin の OPTIONS preflight はここで short-circuit）
2. request ID を発行する
3. App Check を検証する
4. Firebase ID トークンの免除パス（`GET /v1/app-config`、`POST /v1/telemetry/frames`）以外では Firebase ID トークンを検証する
5. Zod でリクエストを検証する
6. 認可とデータ操作を行う
7. 統一エラーと構造化ログを確定する

認証バイパスは local / dev / prod のいずれにも設けない。単体・結合テストは検証器を依存注入し、実通信テストは dev Firebase が発行した正規トークンを使う。

<!-- @code backend/src/middleware/cors.ts#createCorsMiddleware -->
### CORS（Web QA）

ブラウザからの **dev** Web QA アクセスのため、App Check より前に CORS を適用する。
緩和は binding `WEB_QA_PAGES_PROJECT` が設定されている環境（local / `env.dev`）でのみ有効で、
prod（`env.prod`）では空文字を明示して allowlist を空にする。空文字は未設定と同じく全 origin 拒否だが、
未定義のままだと wrangler が「top-level の vars が継承されない」警告を prod 系コマンドで毎回出し、
本当の設定ミスがノイズに埋もれるため、無効化の意図を値として置く。

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

免除パス（`GET /v1/app-config`、`POST /v1/telemetry/frames`）を除く全エンドポイントで `Authorization: Bearer <token>` を必須とする。免除は完全一致で判定し、`backend/src/auth/middleware.ts` の `idTokenExemptPaths` を唯一の定義とする（OpenAPI 検証も同じ一覧を参照する）。以下を検証し、成功時の `sub` をリクエスト利用者の UID とする。

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

`GET /v1/app-config` は D1 の `app_config` 単一行を返す。Firebase ID トークンは不要だが App Check は必須とする。単一行がなければ500とし、暗黙の既定値では起動を続けない。`perfTelemetryEnabled` はフレーム計測テレメトリの kill switch を兼ねる。

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

- 登録前に前後空白を除去し NFC 正規化する。`POST /v1/words` は言葉単体の明示登録専用で、新規は 201、既存への明示登録・公開昇格は 200
- `POST /v1/words` は結果種別 `registrationResult` を返す。新規作成は `created`、最初の明示登録をそのリクエストが行った場合は `promoted`、既に明示登録されていた場合は `alreadyPublic`。判定は `first_registered_at` を設定する UPDATE の結果から取り、同時リクエストでも `promoted` は 1 回だけになる。公開定義だけで見えていた言葉（`first_registered_at` が null）への登録は言葉登録 activity を新たに生むため `promoted` とする
- `GET /v1/words/lookup` は登録前の既存語チェック専用で、正規化後の `(表記, よみ)` 完全一致かつ閲覧者にとって公開されており、さらに明示登録済みの言葉だけを返す。非公開の言葉と、公開定義だけで見えている未登録の言葉は `null` を返す。よみの文字種は検証しない
- 言葉の同一性は `(表記, よみ)` の完全一致とする。表記が同じでもよみが異なれば別の言葉として登録する（例: 金星＝きんせい / きんぼし）。同一の `(表記, よみ)` は重複して作らない
- 新規 ID は UUIDv7、読みグループは正規化済み reading からサーバーが算出する
- 最初の明示登録日時・登録者と、ユーザーごとの `word_registrations` を保持する。同じユーザーの再登録は冪等で、別ユーザーの再登録は最初の登録日時を更新しない
- 公開経路（みんなの辞書・検索・保存一覧・直接取得・タイムラインの言葉登録）は、ミュートしていない明示登録または公開定義がある言葉だけを返す。閲覧権限のない直接取得は 404 `word_not_found`
- 言葉の修正は登録後1時間以内かつ、行の作成者と最初の明示登録者が同一の本人で、他ユーザーの定義または保存がない場合だけ許可する
- 一覧は reading の文字種クラス（五十音 → 英字 → 数字・記号）と reading、id の安定順とし、指定された行、定義有無、検索語を適用する

<!-- @code backend/src/definitions/definition-service.ts#DefinitionService -->
<!-- @code backend/src/db/schema.ts#definitions -->
### 定義

- public / private は作成時に `finalized_at` を持ち、以後更新しない
- `POST /v1/definitions` は `wordId` または `word` + `reading` のいずれか一方を受け付ける。後者ではサーバーが言葉を解決／必要時に内部作成してから定義を作成する。内部作成は明示登録にしない
- 許可する状態遷移は public と private の相互切替だけとする。Draft（下書き）は採用しない
- `PATCH /v1/definitions/{id}` の更新対象は本文と公開範囲のみ。言葉の付け替えは受け付けない
- 作成後1時間を超えた本文編集を403で拒否する。公開範囲の変更では `finalized_at` を更新しない
- 他者は public だけを閲覧でき、本人は自分の private も閲覧できる。不可視な定義は404として存在を秘匿する
- 削除は所有者だけが実行でき、`deleted_at` を設定する
- いいね対象は他者が閲覧可能な public 定義と、自分が閲覧可能な自分の定義に限定する

<!-- @code backend/src/browse/browse-service.ts#BrowseService -->
### 辞書と一覧

- 公開辞書は対象ユーザーの public 定義だけを言葉単位にまとめる
- 本人向け辞書は private を含め、endpoint ごとの status 条件を適用する
- みんなの辞書、公開辞書、本人の定義済み言葉、保存した言葉は、サーバーが正規化済み reading から算出した `readingSubGroup` を返す。分類規則の正本はサーバーとし、クライアントは再計算しない
- 辞書の索引一覧は reading の文字種クラス（五十音 → 英字 → 数字・記号）、reading、id の安定順で返す。クライアントは受信順を維持し、`readingSubGroup` からセクション見出しだけを導く
- 保存した言葉はセクションを持たない一覧として保存日時、id の降順で返す
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

<!-- @code backend/src/telemetry/frame-stats-service.ts#FrameStatsService -->
<!-- @code backend/src/telemetry/retention.ts#runTelemetryRetention -->
## フレーム計測テレメトリ

`POST /v1/telemetry/frames` はセッション単位・画面単位に集計済みのフレーム統計を受け取り、202 で `accepted`（保存件数）と `disabled`（kill switch で破棄したか）を返す。Firebase ID トークンは不要だが App Check は必須とする。1 リクエストの `screens` は1〜50件、各カウンタは `frameCount` 以下であることを検証し、違反は400とする。

保存先はアプリ本体の `DB` ではなく専用の `TELEMETRY_DB` とする。書き込み量と保持期間がアプリデータと大きく異なり、削除運用と障害影響をアプリ本体から切り離すためである。保存するのは件数・合計・最大だけとし、生フレーム、パーセンタイル、`user_id` は保存しない。`session_id` は端末のセッション単位で使い捨てる識別子で、利用者と紐づけない。1 リクエストは1バッチで書き込み、部分挿入を残さない。

kill switch はクライアント任せにせずサーバー側で強制する。受信ハンドラはリクエストごとに `app_config.perf_telemetry_enabled` を読み、false なら1行も書かずに `accepted=0` / `disabled=true` を返す。`app_config` 行が存在しない場合も受信しない。`GET /v1/app-config` の `perfTelemetryEnabled` は同じ行を返すため、クライアントは送信自体を止められるが、停止の正はサーバー側の判定である。

リテンションは30日で、Scheduled Handler が `scheduledTime - 30日` より古い `created_at`（サーバー受信時刻）の行を削除し、削除件数を構造化ログに記録する。クライアント指定の `recorded_at` は分析時刻として残し、保持期限の基準には使わない。物理削除とテレメトリのリテンションは独立に `waitUntil` し、一方の失敗がもう一方を止めない。

| 環境 | テレメトリ D1 |
|---|---|
| local | `teigiii-telemetry-local` |
| dev | `teigiii-telemetry-dev` |
| prod | `teigiii-telemetry-prod` |

migration は本体とは別系統（`backend/drizzle-telemetry`）で、`just backend-migrate-dev-telemetry` / `just backend-migrate-prod-telemetry` で適用する。dev は `just backend-deploy-dev` からも依存として実行するが、**prod は `just backend-deploy-prod` の依存に含めない**（「環境」節の理由による）。prod では `just backend-migrate-prod-telemetry` を個別に実行する。

分析はダッシュボードを作らず、`just perf-report`（定型 JSON）と `just perf-query`（手動 raw SQL）で prod `TELEMETRY_DB` を読む。分析導線は D1 Read のみの API token（`CLOUDFLARE_API_TOKEN`）を使い、AI の主導線は `perf-report` に限定する。mutation の実効防御は `perf-query` の SELECT/WITH ガード（D1 Read が Cloudflare 側で書き込みを拒否する前提にはしない）。詳細は [app-performance-telemetry.md](app-performance-telemetry.md) の「分析導線」と `.claude/skills/analyzing-app-performance/SKILL.md`。

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
2. `just backend-deploy-dev` を実行する。このコマンドは本体 D1 / テレメトリ D1 の migration、`app_config` 初期行の冪等な作成、`teigiii-api-dev` の deploy を順に行う。
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

recipe は `nix develop` の中で実行する。wrangler は `node_modules/.bin/wrangler` の
shebang 経由で node に起動されるため Node.js 22 以上を要求し、shell 外の node バージョンに
依存すると手順の途中で止まる。node は `flake.nix` で固定している。

1. `just backend-drift-check` で prod と `origin/develop` の乖離（未 deploy の commit /
   未適用 migration）を洗い出す。
2. `just backend-validate-prod` で `teigiii-api-prod`、`teigiii-prod`、
   `teigiii-prod-avatars`、prod Firebase vars の bundle / bindings 解決を dry-run する。
3. **配信済みアプリとの後方互換**を確認する（後述）。壊す変更があれば互換シムを先に入れる。
4. 未適用の migration がある場合、その性質に応じて順序を決めて実行する。
   **`just backend-deploy-prod` は migration を実行しない。**
   - 実行前に `just backend-bookmark-prod` で Time Travel bookmark を控える（後述）
   - additive（列・テーブルの追加）: `just backend-migrate-prod` /
     `just backend-migrate-prod-telemetry` を先に実行してから 5 へ進む
   - destructive（列の削除・リネーム。drizzle-kit が table recreate を吐く）:
     先に 5 で新コードを deploy し、その後に migration を実行する
5. `just backend-deploy-prod` を実行する。この recipe は `backend-guard-prod`
   （作業ツリー clean / `origin/develop` と一致 / その commit の `ci-passed` が green）
   を通過した場合にだけ prod Worker を deploy し、その commit を `DEPLOYED_SHA` として打つ。
6. `just backend-drift-check` が green になることを確認し、prod の主要フローを smoke test する。

R2 public access は有効化しない。Cron は Wrangler 設定を正本とし、UTC の実行時刻を
変更する場合はデプロイ前に確認する。

<!-- @code backend/src/compat/draft-count-shim.ts#withDraftCount -->
#### 配信済みアプリとの後方互換

migration の additive / destructive とは別軸の判断で、**Worker deploy によるレスポンス形状の変更**が
ストアで配信済みのアプリを壊さないかを見る。生成クライアント（dart-dio + json_serializable）は
`$checkKeys(requiredKeys:)` で必須キーの存在だけを検査し、未知キーは無視する。したがって:

- レスポンスのプロパティ追加・新規エンドポイント追加は安全
- リクエストのプロパティ削除は安全（zod は非 strict で未知キーを strip する）
- **レスポンスの必須プロパティ削除は破壊的**。配信済みアプリの当該画面が parse エラーで落ちる

判定は、配信済みバージョンの tag（例 `v1.2.1+11`）の `backend/openapi.json` と現行の差分を取り、
required から消えたプロパティの有無で行う。破壊的な削除がある場合は、契約（OpenAPI）へ戻さず
配信レスポンスにだけ定数を足す**互換シム**を入れてから deploy する（`backend/src/compat/`）。
シムは `min_app_version_ios` / `min_app_version_android` を該当バージョンより上へ引き上げた後に撤去する。

#### バックアップと復旧（D1 Time Travel）

migration は forward-only で down migration を持たない。戻し手段は D1 Time Travel だけだが、
**Time Travel restore は失敗時の通常対応ではない。** 対応は失敗の種類で分かれる。

1. migration の直前に `just backend-bookmark-prod` を実行し、出力された bookmark を控える
   （Issue / PR に貼る。控えを取らないまま migration を流さない）
2. **`wrangler d1 migrations apply` がエラーを返した場合**: その migration はロールバックされて
   未適用のまま残り、それ以前に成功した migration は適用済みのまま残る。`just backend-drift-check`
   で `d1_migrations` の適用状態を確認し、migration SQL を修正して再実行する。ここで restore しない
   （同じ状態へ戻すために bookmark 以降の書き込みを失うだけになる）
3. **migration が成功した後に、意味的に誤った状態やデータ欠損が判明した場合**: `just backend-restore-prod <bookmark>`
   で復元する。destructive な migration は table recreate になり、D1 は暗黙トランザクション内で
   `PRAGMA foreign_keys=OFF` が効かないため、cascade 参照している行（`likes` → `definitions`）を
   退避・復元する構成に依存する。ここが誤っていると **成功したまま行が失われる**ので、この経路が
   restore の主な用途になる。restore は破壊的な上書きで bookmark 以降の書き込みを失うため、
   recipe は明示的な確認入力を求める。判断は速やかに行う
4. 復元したら `just backend-drift-check` で適用状態を確認してから再実行する

#### prod app_config の運用

- 確認: `just backend-app-config-prod`（読み取りのみ）
- 初期行の作成: `just backend-seed-prod`（冪等。既存行があれば no-op）
- 強制アップデート下限の更新: `just backend-set-min-app-version-prod <ios> <android>`。
  更新前後の行を表示するので、値の変化を Issue / PR に記録する

#### ドリフト検知

prod は手動 deploy のため「deploy し忘れ」「migration の適用し忘れ」を誰も検知しない。
`just backend-drift-check` は prod へ書き込まずに次を照合し、乖離があれば非 0 で終了する。

- prod Worker の `DEPLOYED_SHA`（deploy 時に `backend-deploy-prod` が打つ）と `origin/develop`
- prod `DB` / prod `TELEMETRY_DB` の未適用 migration

定期実行して能動的に通知する導線は、**#291 のリリース回帰検知 Cron に相乗りさせる**方針とする。
単独の Cron を先に建てると `scheduled` handler の `controller.cron` dispatch 設計を #291 側で
やり直すことになるため、それまでは prod deploy 手順と手動実行で担保する。

### 使用量監視と通知

- Workers request / CPU、D1 rows read / written と storage、R2 storage / Class A / Class B operations を各 product の Analytics で確認する。
- Pay-as-you-go account では Cloudflare Dashboard の `Manage Account > Billing > Billable Usage > Create budget alert` から account 全体の USD 閾値と通知先を設定する。
- Professional 以上かつ Pay-as-you-go で product 別通知が利用できる場合は `Notifications > Add > Billable Usage` から Workers / R2 等の閾値を設定する。
- budget alert と usage notification は停止・上限制御ではない。通知後は Billable Usage と product Analytics を確認し、想定外の呼び出し元、Cron 頻度、D1 query、R2 operation を切り分ける。

参考: [Cloudflare Budget alerts](https://developers.cloudflare.com/billing/manage/budget-alerts/)、[Usage-based billing](https://developers.cloudflare.com/billing/understand/usage-based-billing/)、[Cron Triggers](https://developers.cloudflare.com/workers/configuration/cron-triggers/)

Firebase / Cloudflare の秘密情報は Wrangler secrets、GitHub secrets、または実行中の shell 環境だけに置き、リポジトリやログへ保存しない。
