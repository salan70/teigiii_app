# データ移行 & big-bang 一斉切替（issue #186）

親戦略: `doc/plans/2026-07-12-cloudflare-migration-strategy.md`（フェーズ 5）

## 目的

Firestore → D1、Firebase Storage → R2 の移行スクリプトを作成し、`force_event` による一斉切替を実施する。全ユーザー・定義・いいね・フォロー関係を完全保全する。

## 決定事項

### 1. 切替時 404 問題: メンテフリーズ + クライアント自己修復（差分移行は不採用）

旧アプリ（Firestore 版バイナリ）のメンテナンスモードは `main.dart` の `builder` で UI に overlay を被せるだけで、`AuthGuard` の匿名サインアップ（Firebase Auth 登録 + Firestore プロフィール作成）はメンテ中でも実行される。さらに切替後も、ストア更新前の旧バイナリの初回起動で D1 に存在しない Auth ユーザーが恒久的に発生し得る。

- **採用**: メンテフリーズ（切替手順の前提）+ クライアント自己修復（新アプリで既存の起動時バージョン情報更新（`PATCH /v1/users/me`）が 404 `user_not_found` の場合、`POST /v1/users` で再登録する。検知用の `GET` は追加しない）
- **不採用**: 差分移行。メンテ開始後に発生する新規ユーザーはデフォルト名の空プロフィールのみ（UI 遮断により投稿等は不可能）で、自己修復による再生成で実害がない。一方、差分移行は一回きりの対処であり孤児 Auth ユーザーの恒久的な発生を構造的に塞げず、増分抽出の実装コストに価値が見合わない
- issue #186 コメントの「1（差分移行）を軸に」は本決定で上書きする

### 2. スクリプト構成: ローカル実行 TS + wipe-and-reload

- `server/scripts/migration/` に TypeScript スクリプトを置き、ローカルから bun で実行する（Worker 上では実行しない）
- **export**: `firebase-admin` SDK で全コレクションを読み、git 管理外ディレクトリに NDJSON スナップショットとして保存。gcloud マネージドエクスポート（GCS 経由）は使わない
- **transform + import**: スナップショット → 変換 → SQL 生成 → `wrangler d1 execute --remote --file` で投入。R2 は firebase-admin で読み `wrangler r2 object put` で投入
- **冪等性**: wipe-and-reload。実行のたびに D1 全行 DELETE → スナップショットから全量再投入。途中失敗時は再実行するだけでよい。R2 は決定的キー（`avatars/{uid}`）への上書きで冪等
- サービスアカウントキー（dev/prod）はローカル配置・git 管理外

### 3. 不整合データのポリシー

「プロダクト上の意味が消えているデータは捨てる、意味の判断が必要なデータは止めて人間に聞く」

| ケース | 対処 |
|---|---|
| words の重複（trim + NFC 後に同一になる 2 語） | **自動マージ**: createdAt 最古（同値なら id 昇順）を正とし、他方の word に付いた定義を正へ付け替える。定義は 1 件も捨てない。マージ内容は移行レポートに記録。当初は fail-fast だったが、リハーサルで完全同一文字列の重複ドキュメント 7 組（旧システムに一意性制約がなかったため）が実在すると判明し、本方針に変更 |
| FK 孤児（削除済みユーザーの定義・いいね・フォロー・ミュート、削除済み定義へのいいね等） | **drop + ログ**: 移行レポートに件数と ID を記録して捨てる |
| 欠損（`UserProfiles` はあるが `UserConfigs` がない等） | **デフォルト値補完**（`'unknown'` 等）+ ログ |
| `profileImageUrl` が既知パターン外の URL | **fail-fast** |

### 4. データ変換対応表

| 旧（Firestore） | 新（D1） | 備考 |
|---|---|---|
| `UserProfiles` + `UserConfigs` | `users` | `lastOsVersion` / `lastAppVersion` は `UserConfigs` から。`avatarKey` は R2 コピー結果（下記） |
| `UserConfigs.mutedUserIdList` | `user_mutes` 行 | `createdAt` = 移行実行時刻（元データに存在しないため） |
| `UserFollowCounts` | （破棄） | `follows` の COUNT で算出 |
| `Words` | `words` | `word` は trim + NFC 再正規化。`readingSubGroup` はサーバーと同じ関数（`server/src/words/reading-sub-group.ts`）で再計算。`createdBy` = NULL（元データに存在しない） |
| `Definitions` | `definitions` | `status` = `isPublic ? 'public' : 'private'`（旧データに draft はない）。`finalizedAt` = `createdAt`。`isEdited` は引き継ぐ。非正規化フィールド（`word` / `likesCount` 等）は破棄 |
| `WordDefinitionRelations` | （破棄） | `Definitions.wordId` を正とする派生データ |
| `Likes` | `likes` | そのまま |
| `UserFollows` | `follows` | そのまま |
| `AppConfig` | （移行しない） | D1 `app_config` は事前準備で手動設定 |
| — | `saved_words` | 新機能。空 |

**アバター（Firebase Storage → R2）**: `profileImageUrl` を分類し、いずれも `avatars/{uid}` へコピーして `avatarKey` に設定する
- デフォルト URL 3 種（旧 `lib/util/constant/url.dart` の `defaultIconImageUrlListForProd` / `ForDev`）のいずれかに一致 → 該当のデフォルト PNG をコピー（ハッシュ割当への変更で既存ユーザーのアイコンが変わるのを防ぐ。issue #186 コメント参照）
- `users/{uid}/profile_image.png` を指す → カスタム画像をコピー
- それ以外 → fail-fast

### 5. 検証: 全件・全フィールド突合（サンプリングなし）

戦略 doc の「サンプルレコード突合」を全件突合に上書きする（個人アプリ規模では全件が現実的で、妥協する理由がない）。

- 照合スクリプトは変換スクリプトから独立した検証器として書く。スナップショット NDJSON から期待される D1 状態を再計算し、D1 実データと突合する（変換のロジック・取得経路を使い回すと変換バグが照合でも再現し検出できない）
- テーブルごとの件数照合 + 全レコード・全フィールド一致
- 意図的な差分（孤児 drop・デフォルト値補完・正規化再計算）は移行レポートの件数と照合結果の整合まで確認する
- R2 は `avatarKey` を持つ全ユーザーについてオブジェクト存在 + バイトサイズ一致を確認する

### 6. リハーサル: prod スナップショット × 専用一時リソース

- prod からのエクスポートは読み取りのみで本番無停止・安全
- 投入先はリハーサル専用に一時作成した D1 データベースと R2 バケット（`wrangler d1 create` 等。検証後に削除）。dev 環境の D1/R2 は dev アプリの動作確認と干渉するため使わない
- export → transform → import → 全件突合まで本番と同一手順を通しで実行する。word 正規化衝突・FK 孤児の実在件数はここで判明する
- 実機での表示確認はリハーサルでは行わず、切替当日の本番投入後の目視確認で行う

### 7. ストア審査の考慮: prod インフラを提出前に整備し、スナップショットを事前投入

App Store の審査員は提出バイナリを実際に起動・操作する。新アプリは起動直後に prod Workers API へアクセスする（`GET /v1/app-config`、匿名登録の `POST /v1/users`）ため、**提出より前に** prod インフラ一式（Worker デプロイ・D1 マイグレーション・`app_config` 行・実 URL のビルド反映）が稼働している必要がある。

- prod Worker の URL は workers.dev（`https://teigiii-api-prod.tetsuo21ad.workers.dev`）を使う。将来カスタムドメインへ移す場合はアプリ更新で切り替える
- 審査前に本番と同一手順で prod D1/R2 へスナップショットを投入する（審査員に実データを見せる + 本番手順の追加リハーサル。wipe-and-reload のため切替当日にやり直すだけでよく、鮮度は問わない）
- 審査中に prod D1 へ作られる審査員アカウントは切替当日の wipe-and-reload で消えるが、使い捨てであり、パターンとしても自己修復で救済されるため無害
- 手動リリース待機により、審査通過後も切替当日まで実ユーザーに新バイナリは配信されない。既存ユーザー（旧バイナリ = Firestore 参照）への影響は一切ない

### 8. Android はスコープ外

Google Play は配信停止中のため、提出・リリース・強制アップデートの対象は App Store のみ。`app_config.minAppVersionAndroid` は参照されないが、スキーマ上必要なため iOS と同値を形式的に設定する。

### 9. 「書き込み停止確認」の読み替え

戦略 doc の「旧バージョンの書き込み停止を確認してからエクスポート」は厳密には達成不可能。メンテ中も旧アプリは起動時に (a) `UserConfigs` のバージョン情報更新、(b) 新規匿名登録、を書き込む。(a) は喪失許容（実害なし）、(b) は自己修復で救済済み。よって「実質的な書き込み（投稿・いいね等）が UI 遮断で停止していることの確認」と読み替える。スナップショットはエクスポート時点のファイルとして確定し、以後不変として扱う。

## 実行手順

### PR 1: クライアント自己修復（Flutter）

既存の起動時バージョン情報更新（`PATCH /v1/users/me`）が 404 `user_not_found` の場合、`POST /v1/users` で再登録する（既存の初回登録フローを再利用。Firebase Auth ユーザーは存在するためサーバー登録のみ。検知用の `GET` は追加しない）。

### PR 2: 移行スクリプト一式（`server/scripts/migration/`）

- `export`: Firestore 全コレクション + Storage アバター一覧 → NDJSON スナップショット
- `transform` + `import`: 変換 → SQL 生成 → D1 投入、R2 アバターコピー。移行レポート（drop/補完の件数と ID）出力
- `verify`: 独立検証器による全件突合
- 変換ロジックの純粋関数部分に vitest テスト

### リハーサル（コード変更なし)

専用一時 D1/R2 に対して全手順を通しで実行。結果（件数・衝突/孤児の実在数・突合結果）を issue #186 にコメントで記録。衝突が実在した場合はここで対処を決める。

### 切替

**事前準備（切替日より前。順序厳守 — 審査員が prod API を実際に叩くため、インフラ整備が提出より先）**
1. PR 1 / PR 2 マージ、リハーサル完了（一時 D1/R2 に対して export → import → verify、結果を issue #186 に記録、一時リソース削除）
2. prod インフラ整備（この項内も順序厳守）
   1. リリースバージョンを `1.1.0+8` に更新する。`server/wrangler.toml` の `env.prod.vars.AVATAR_BASE_URL`、`dart_defines/prod.json` の `apiBaseUrl`、`ios/Flutter/Prod.xcconfig` の `apiBaseUrl` を実 URL（`https://teigiii-api-prod.tetsuo21ad.workers.dev`）に置換する。**必ずデプロイより前に行う**（デプロイ済み Worker の vars はローカル置換では更新されず、プレースホルダ URL のまま審査に進んでしまうため）。Dart defines と Xcode build setting の双方が TestFlight ビルドより前の必須条件である
   2. prod Worker デプロイ
   3. prod D1 マイグレーション適用・R2 バケット作成
   4. `app_config` 行を冪等 upsert で投入する（D1 の列は snake_case、`updated_at` は NOT NULL の Unix ミリ秒。`CHECK(id = 1)` のため `id = 1` 固定）:

      ```bash
      cd server
      bunx wrangler d1 execute teigiii-prod --remote --command \
        "insert into app_config (id, min_app_version_ios, min_app_version_android, in_maintenance, maintenance_scheduled_end_time, updated_at)
         values (1, '1.1.0', '1.1.0', 0, null, unixepoch('now') * 1000)
         on conflict(id) do update set
           min_app_version_ios = excluded.min_app_version_ios,
           min_app_version_android = excluded.min_app_version_android,
           in_maintenance = excluded.in_maintenance,
           maintenance_scheduled_end_time = excluded.maintenance_scheduled_end_time,
           updated_at = excluded.updated_at"
      ```

   5. prod Firebase の有効な App Check トークンを付けて `GET /v1/app-config` の成功と設定値を確認する（DB 行の存在だけでなく、prod Worker・D1 binding・App Check 検証まで通ることの確認）:

      ```bash
      curl --fail-with-body -H "X-Firebase-AppCheck: <valid prod App Check token>" \
        https://teigiii-api-prod.tetsuo21ad.workers.dev/v1/app-config
      # minAppVersionIos / minAppVersionAndroid = 1.1.0、inMaintenance = false を確認
      ```
3. 本番と同一手順で prod D1/R2 へスナップショット投入（export → import → verify）
4. TestFlight ビルドで prod バックエンド疎通を実機確認（App Check・匿名登録・既存データ表示まで）
5. 新バージョンを App Store に提出し、審査通過済み・**手動リリース待機**の状態にする
6. Cloudflare 無料枠の使用量通知を設定（Workers リクエスト数、D1 読み書き行数、R2 ストレージ/操作数）

**切替当日（runbook）**
1. Firestore `AppConfig` を `inMaintenance = true` に設定（+ `maintenanceScheduledEndTime`）。旧アプリはメンテ表示になる
2. エクスポート実行 → スナップショット確定
3. transform + import（prod D1 wipe-and-reload、R2 アバターコピー）
4. 全件突合を実行
   - **NG**: `inMaintenance = false` に戻して中止（= ロールバック。旧環境は無傷。D1 の中途データは次回 wipe されるので放置可）
   - **OK**: 次へ
5. App Store で手動リリース実行
6. ストアで新版がダウンロード可能になったことを実機で確認する（先に強制アップデートを発動すると「新版がストアにない」状態に陥るため、この順序を厳守）
7. Firestore `AppConfig` の `minAppVersion` を新バージョンへ引き上げ + `inMaintenance = false`。旧アプリは強制アップデート表示へ移行
8. 新アプリで既存データの表示を実機確認

## 完了条件

- prod の全件突合がパスし、新バージョンが App Store で公開済み（Android は配信停止中のためスコープ外）
- 旧アプリで強制アップデートが表示されることを実機確認済み
- 新アプリで既存ユーザーのデータ（プロフィール・定義・いいね・フォロー・デフォルトアイコン維持）が見えることを実機確認済み
- Firestore / Firebase Storage の旧データは削除せず保持している（戦略どおり）
- Cloudflare 無料枠の使用量通知が設定済み
