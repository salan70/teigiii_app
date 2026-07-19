# データ移行 & big-bang 一斉切替（issue #186）

親戦略: `doc/plans/2026-07-12-cloudflare-migration-strategy.md`（フェーズ 5）

## 目的

Firestore → D1、Firebase Storage → R2 の移行スクリプトを作成し、`force_event` による一斉切替を実施する。全ユーザー・定義・いいね・フォロー関係を完全保全する。

## 決定事項

### 1. 切替時 404 問題: メンテフリーズ + クライアント自己修復（差分移行は不採用）

旧アプリ（Firestore 版バイナリ）のメンテナンスモードは `main.dart` の `builder` で UI に overlay を被せるだけで、`AuthGuard` の匿名サインアップ（Firebase Auth 登録 + Firestore プロフィール作成）はメンテ中でも実行される。さらに切替後も、ストア更新前の旧バイナリの初回起動で D1 に存在しない Auth ユーザーが恒久的に発生し得る。

- **採用**: メンテフリーズ（切替手順の前提）+ クライアント自己修復（新アプリで起動時 `GET /v1/users/me` が 404 `user_not_found` の場合、`POST /v1/users` で再登録する）
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
| words の正規化衝突（trim + NFC 後に同一になる 2 語） | **fail-fast**: 衝突リストを出力して異常終了。自動マージは実装しない。リハーサルで実在が判明した場合のみ対処を決める |
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

### 7. 「書き込み停止確認」の読み替え

戦略 doc の「旧バージョンの書き込み停止を確認してからエクスポート」は厳密には達成不可能。メンテ中も旧アプリは起動時に (a) `UserConfigs` のバージョン情報更新、(b) 新規匿名登録、を書き込む。(a) は喪失許容（実害なし）、(b) は自己修復で救済済み。よって「実質的な書き込み（投稿・いいね等）が UI 遮断で停止していることの確認」と読み替える。スナップショットはエクスポート時点のファイルとして確定し、以後不変として扱う。

## 実行手順

### PR 1: クライアント自己修復（Flutter）

起動時 `GET /v1/users/me` が 404 `user_not_found` の場合、`POST /v1/users` で再登録する（既存の初回登録フローを再利用。Firebase Auth ユーザーは存在するためサーバー登録のみ）。

### PR 2: 移行スクリプト一式（`server/scripts/migration/`）

- `export`: Firestore 全コレクション + Storage アバター一覧 → NDJSON スナップショット
- `transform` + `import`: 変換 → SQL 生成 → D1 投入、R2 アバターコピー。移行レポート（drop/補完の件数と ID）出力
- `verify`: 独立検証器による全件突合
- 変換ロジックの純粋関数部分に vitest テスト

### リハーサル（コード変更なし)

専用一時 D1/R2 に対して全手順を通しで実行。結果（件数・衝突/孤児の実在数・突合結果）を issue #186 にコメントで記録。衝突が実在した場合はここで対処を決める。

### 切替

**事前準備（切替日より前）**
1. PR 1 / PR 2 マージ、リハーサル完了
2. 新バージョンを App Store / Google Play に提出し、審査通過済み・**手動リリース待機**の状態にする
3. prod の D1 マイグレーション適用・R2 バケット・`app_config` 行（`minAppVersion` = 新バージョン、`inMaintenance` = false）を整備
4. Cloudflare 無料枠の使用量通知を設定（Workers リクエスト数、D1 読み書き行数、R2 ストレージ/操作数）

**切替当日（runbook）**
1. Firestore `AppConfig` を `inMaintenance = true` に設定（+ `maintenanceScheduledEndTime`）。旧アプリはメンテ表示になる
2. エクスポート実行 → スナップショット確定
3. transform + import（prod D1 wipe-and-reload、R2 アバターコピー）
4. 全件突合を実行
   - **NG**: `inMaintenance = false` に戻して中止（= ロールバック。旧環境は無傷。D1 の中途データは次回 wipe されるので放置可）
   - **OK**: 次へ
5. 両ストアで手動リリース実行
6. ストアで新版がダウンロード可能になったことを実機で確認する（先に強制アップデートを発動すると「新版がストアにない」状態に陥るため、この順序を厳守）
7. Firestore `AppConfig` の `minAppVersion` を新バージョンへ引き上げ + `inMaintenance = false`。旧アプリは強制アップデート表示へ移行
8. 新アプリで既存データの表示を実機確認

## 完了条件

- prod の全件突合がパスし、新バージョンが両ストアで公開済み
- 旧アプリで強制アップデートが表示されることを実機確認済み
- 新アプリで既存ユーザーのデータ（プロフィール・定義・いいね・フォロー・デフォルトアイコン維持）が見えることを実機確認済み
- Firestore / Firebase Storage の旧データは削除せず保持している（戦略どおり）
- Cloudflare 無料枠の使用量通知が設定済み
