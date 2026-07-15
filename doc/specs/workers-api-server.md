# Workers API サーバー仕様

## 責務と境界

Workers API は Firebase Auth で認証された利用者に対し、D1 上の teigiii データと R2 上のアバターを REST API として提供する。HTTP のフィールド・ステータス定義は `server/openapi.json` を正本とし、本書は認証、認可、可視性、状態遷移、並び順、運用上の振る舞いを定義する。

Firebase Auth、App Check、Analytics、Crashlytics は継続利用する。Workers から Firebase Admin SDK は利用せず、公開鍵による JWT 検証だけを行う。

Flutter repository の接続、Firestore / Firebase Storage の既存データ移行、prod デプロイは本仕様の実装後にそれぞれ #185、#186 で行う。

## 環境

| 環境 | Worker | Firebase | D1 | R2 | 配信 |
|---|---|---|---|---|---|
| local | `wrangler dev` | dev project | local D1 | local R2 | ローカル |
| dev | `teigiii-api-dev` | dev project | dev 専用 | dev 専用 | r2.dev |
| prod | `teigiii-api-prod` | prod project | prod 専用 | prod 専用 | R2 custom domain |

Firebase project ID と project number は公開識別子として Wrangler vars に置く。トークン、秘密鍵、Cloudflare API token はコード、設定ファイル、ログへ保存しない。

dev は `just server-deploy-dev` で手動デプロイする。prod のデプロイと Cron 有効化は #186 の一斉切替手順だけから行い、自動デプロイ CI は導入しない。

## リクエスト保護

<!-- @code server/src/auth/middleware.ts#createAppCheckMiddleware -->
<!-- @code server/src/auth/middleware.ts#createFirebaseAuthMiddleware -->
### 適用順序

1. request ID を発行する
2. App Check を検証する
3. `GET /v1/app-config` 以外では Firebase ID トークンを検証する
4. Zod でリクエストを検証する
5. 認可とデータ操作を行う
6. 統一エラーと構造化ログを確定する

認証バイパスは local / dev / prod のいずれにも設けない。単体・結合テストは検証器を依存注入し、実通信テストは dev Firebase が発行した正規トークンを使う。

<!-- @code server/src/auth/app-check.ts#AppCheckTokenVerifier -->
### App Check

全エンドポイントで `X-Firebase-AppCheck` ヘッダーを必須とする。公式 JWKS `https://firebaseappcheck.googleapis.com/v1/jwks` を使い、以下を検証する。

- 署名
- header の `alg=RS256`、`typ=JWT`、非空 `kid`
- `iss=https://firebaseappcheck.googleapis.com/<project_number>`
- `aud` に `projects/<project_number>` が含まれること
- `exp` が未来であること
- `sub` が非空の App ID であること

`sub` の App ID は認証コンテキストに保持するが、許可リストでは制限しない。limited-use token とリプレイ検知は行わない。

<!-- @code server/src/auth/firebase-id-token.ts#FirebaseIdTokenVerifier -->
### Firebase ID トークン

`GET /v1/app-config` を除く全エンドポイントで `Authorization: Bearer <token>` を必須とする。以下を検証し、成功時の `sub` をリクエスト利用者の UID とする。

- 署名
- header の `alg=RS256`、非空 `kid`
- `exp` が未来、`iat` が未来でないこと
- `aud=<project_id>`
- `iss=https://securetoken.google.com/<project_id>`
- `sub` が非空文字列であること

トークン失効確認は行わず、最長1時間の自然失効を許容する。

<!-- @code server/src/auth/firebase-public-keys.ts#FirebasePublicKeyProvider -->
### 公開鍵キャッシュ

Firebase ID トークンの X.509 公開鍵は Google の公式 endpoint から取得する。レスポンスの `Cache-Control: max-age` まで isolate 内でインポート済み CryptoKey を再利用する。ヘッダーが不正または欠落している場合の再取得間隔は5分とする。

未知の `kid` を受け取った場合は、有効期限内でも一度再取得して鍵ローテーションへ追従する。同一 isolate 内の同時取得は1リクエストにまとめる。再取得後も `kid` がなければ401とする。

## 共通処理

<!-- @code server/src/app.ts#createApp -->
### リクエスト処理順序

Hono app は request context、App Check、Firebase Auth の順に middleware を適用してから `/v1` ルートを実行する。検証済み UID と App ID はヘッダーやリクエスト body から受け取らず、middleware が設定したコンテキストだけを信頼する。

<!-- @code server/src/errors.ts#ApiError -->
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

<!-- @code server/src/middleware/request-context.ts#createRequestContextMiddleware -->
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

### App config

`GET /v1/app-config` は D1 の `app_config` 単一行を返す。Firebase ID トークンは不要だが App Check は必須とする。単一行がなければ500とし、暗黙の既定値では起動を続けない。

運用時の変更は `wrangler d1 execute` で行い、管理 API は追加しない。

<!-- @code server/src/users/user-service.ts#UserService -->
### ユーザー

- `POST /v1/users` は認証 UID を主キーに初回登録し、9桁数字の publicId を暗号学的乱数で生成する。UNIQUE 競合時は再試行し、同じ UID が登録済みなら409 `user_already_exists` を返す
- 自分の取得・更新は認証 UID だけを対象とし、他者の private 情報を返さない
- 他者プロフィールと一覧は論理削除済みユーザーを除外する
- フォローとミュートは自己指定を400で拒否し、対象が不可視なら404とする
- フォローとミュートの追加・解除は冪等とする。フォロワー・フォロー中一覧は関係作成日時、ユーザー ID の降順で keyset pagination する
- アカウント削除はユーザーと所有する定義へ `deleted_at` を設定し、通常 API から即時に不可視とする

<!-- @code server/src/users/user-service.ts#AvatarService -->
### アバター

`PUT /v1/users/me/avatar` は JPEG / PNG を受け付け、Content-Type とファイルシグネチャの両方を検証する。10 MiB を安全上限とし、Workers では画像変換しない。

Issue `#185` の Flutter クライアントは HEIC を含む元画像を切り抜き、512 x 512 JPEG quality 85 に変換して送る。R2 key はユーザー単位で固定し、再アップロードは上書きする。削除は R2 object がなくても成功する。

R2 key は `avatars/<URL エンコード済み Firebase UID>` とし、object の HTTP metadata に検証済み Content-Type を保存する。レスポンスの `avatarUrl` は環境変数 `AVATAR_BASE_URL` と key を結合して解決する。dev は対象 bucket の r2.dev URL、prod は R2 custom domain を `AVATAR_BASE_URL` に設定し、Worker を介さず直接配信する。

### 言葉

- 登録前に前後空白を除去し NFC 正規化する。同一表記は409で既存言葉を返す
- 新規 ID は UUIDv7、読みグループは正規化済み reading からサーバーが算出する
- 言葉の修正は登録後1時間以内かつ、登録者本人で、他ユーザーの定義または保存がない場合だけ許可する
- 一覧は reading、id の安定順とし、指定された行、定義有無、検索語を適用する

### 定義

- draft は `finalized_at=null`、public / private は初回確定時の `finalized_at` を持つ
- 許可する状態遷移は draft から public / private、public と private の相互切替だけとし、draft へ戻さない
- 確定後1時間を超えた本文編集を403で拒否する。公開範囲の変更では `finalized_at` を更新しない
- 他者は public だけを閲覧でき、本人は自分の draft / private も閲覧できる。不可視な定義は404として存在を秘匿する
- 削除は所有者だけが実行でき、`deleted_at` を設定する
- いいね対象は他者が閲覧可能な public 定義と、自分が閲覧可能な自分の定義に限定する

### 辞書と一覧

- 公開辞書は対象ユーザーの public 定義だけを言葉単位にまとめる
- 本人向け辞書は draft / private を含め、endpoint ごとの status 条件を適用する
- 合成 DTO の likesCount、followingCount、followerCount は有効な行だけを集計する
- `isLikedByMe`、`isFollowedByMe`、`isMutedByMe` は認証 UID を基準に算出する

### タイムラインと検索

- 見つけるは public 定義を `finalized_at DESC`、言葉登録を `created_at DESC` として混在させる
- フォロー中はフォロー対象者の public 定義だけを返す
- タイムラインと検索は認証利用者がミュートしたユーザーを除外する
- 言葉検索は表記・よみの部分一致、ユーザー検索は表示名・publicId の部分一致を適用する
- リアクション数順はページ移動中の件数変動による重複・欠落を許容する

## 物理削除

Scheduled Handler は30日以前に論理削除された定義とユーザーを物理削除する。ユーザー削除では R2 アバターを削除してから D1 ユーザーを削除し、FK CASCADE で関連行と定義を削除する。`words.created_by` は SET NULL とし、言葉自体は残す。

処理は再実行可能とし、対象件数、成功件数、失敗件数を構造化ログへ記録する。dev ではローカル scheduled endpoint から手動検証し、prod Cron は #186 で有効化する。

## テストと検証

- 純粋ロジックと SQLite 互換クエリは `bun test`
- Web Crypto、D1、R2、Scheduled Handler は Cloudflare Vitest integration で workerd 上の結合テスト
- OpenAPI 生成物は schema validation とルート集合を検証する
- 主要 D1 クエリは `EXPLAIN QUERY PLAN` で意図した index 利用を確認する
- HEIC から JPEG への変換は #185 で iOS 実機テストする

各 PR で lint、typecheck、format check、全テスト、OpenAPI 差分、DocBridge check を通す。

## 運用

dev デプロイ後は認証付き smoke test で app-config、D1 読み書き、R2 アバター、Scheduled Handler を確認する。Cloudflare Dashboard では Workers request、D1 rows read / written、R2 storage / operation の利用量を確認する。

prod の使用量通知設定とデプロイは #186 の切替チェックリストに含める。Firebase / Cloudflare の秘密情報は Wrangler secrets または GitHub secrets にのみ保存する。
