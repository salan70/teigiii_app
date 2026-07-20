# Workers API サーバー実装

> 注記: ディレクトリ再編（#230）に伴うパス・コマンド表記の書き換えは行っていない。完了時点の記録を保持する。現行構成のパスは `mobile_app/` / `backend/` を参照。

## 目的

Issue #184 のフェーズ 3 として、フェーズ 2 で定義済みの OpenAPI 全ルートを Cloudflare Workers + Hono + Drizzle + D1 上で実装する。Firebase Auth と App Check を検証し、R2 アバター保存、30 日後の物理削除、dev / prod 環境分離までを完成させる。

実装の振る舞いは `doc/specs/workers-api-server.md`、HTTP のリクエスト・レスポンス形状は `server/openapi.json` を正本とする。

## スコープ

- `server/openapi.json` に定義済みの全エンドポイントの実ハンドラ
- Firebase ID トークンと App Check トークンの検証
- D1 を使うクエリ、状態遷移、認可、keyset pagination
- R2 を使うアバターの保存・削除・認証付き Worker URL 解決
- 30 日経過した論理削除データの Scheduled Handler による物理削除
- dev / prod の Wrangler 設定と Cloudflare リソース
- 構造化ログ、テスト、仕様書、DocBridge リンク
- dev Workers への手動デプロイとスモークテスト

## スコープ外

- Flutter repository 層の REST 接続（#185）
- HEIC のサーバー変換。#185 で 512 x 512 JPEG quality 85 に正規化する
- Firestore / Firebase Storage の既存データ移行（#186）
- prod Workers のデプロイと Cron 有効化（#186）
- 自動デプロイ CI、外部ログサービス、CORS、レート制限
- Firebase ID トークンの失効チェック、App Check limited-use token

## 確定した設計

### 環境とデプロイ

- Wrangler のローカル既定環境に加え、dev / prod を別 Worker・別 D1・別 R2 として構成する
- dev / prod のリソースは作成する。#184 では dev のみ手動デプロイし、prod は設定検証までとする
- `just server-deploy-dev` を手動デプロイの正規コマンドとし、自動デプロイは導入しない
- R2 bucket は非公開とし、アバターは App Check と Firebase ID token が必須の Workers API から配信する

### 認証と保護

- App Check は全エンドポイントで必須とする
- Firebase ID トークンは `GET /v1/app-config` 以外で必須とする
- Firebase ID トークンは RS256、kid、exp、iat、aud、iss、非空 sub を検証する
- Firebase 公開鍵は HTTP の Cache-Control に従って isolate 内にキャッシュし、未知の kid では再取得して鍵ローテーションへ追従する
- App Check は公式 JWKS で署名、iss、aud、exp を検証する
- ローカルを含め、アプリケーションコードに認証バイパスを設けない。テストは検証器を依存注入し、実通信は dev Firebase の正規トークンを使う
- JWT、Authorization ヘッダー、App Check トークン、個人情報をログへ出さない

### API とデータ

- 既存の 8 テーブルを使用し、全日時を unix ミリ秒で保存して API 境界で ISO 8601 UTC に変換する
- ID は Firebase UID、移行済み Firestore ID、新規 UUIDv7、9 桁の数字 publicId という確定済み規約を維持する
- 一覧は既存の既定 20 件・最大 50 件の不透明 keyset cursor を使う
- 複数行更新は D1 batch など、D1 上で原子的に完了する方法を使う
- 論理削除済みのユーザー・定義は即時に通常 API から不可視にする
- `app_config` は D1 の単一行を読み、運用変更は `wrangler d1 execute` で行う。管理 API は追加しない

### アバター

- API は JPEG / PNG のみ受け付け、Content-Type とファイルシグネチャを検証する
- サーバー上限は通常到達しない安全弁として 10 MiB とする
- #185 で HEIC を含む選択元画像を 512 x 512 JPEG quality 85 に正規化してから送信する
- R2 オブジェクトキーはユーザー単位で固定し、再アップロードは上書き、削除は冪等とする
- `avatarUrl` は認証付き `GET /v1/avatars/{id}` を指し、Flutter 側も画像取得時に両認証ヘッダーを付ける

### 物理削除

- 30 日経過した論理削除済みの定義とユーザーを Scheduled Handler で物理削除する
- FK の CASCADE / SET NULL を利用し、ユーザーの R2 アバターも削除する
- dev では Scheduled Handler を手動実行して検証し、prod Cron の有効化は #186 に残す

### 可観測性

- リクエスト ID、ルート、ステータス、処理時間を構造化ログへ記録する
- 認証失敗は秘密情報を含めず理由を分類する
- Cron は対象件数、成功件数、失敗件数を記録する
- Cloudflare 使用量通知の手順を仕様書へ記載し、prod での設定は #186 で行う

## 実行手順

### Slice 1: #196 Workers 基盤・認証・共通処理

1. `doc/specs/workers-api-server.md` に環境、認証、エラー、ログの仕様を書く
2. Firebase ID トークンと App Check の検証器について失敗するテストを書く
3. JWT 検証、公開鍵キャッシュ、認証コンテキストを実装する
4. 共通エラー、リクエスト ID、構造化ログを失敗するテストから実装する
5. Workerd 固有部分だけを実行する結合テスト基盤を追加する
6. 主要宣言と仕様節を DocBridge で双方向リンクする

### Slice 2: #192 ユーザー API・R2 アバター

1. ユーザー登録、取得、更新、論理削除を TDD で実装する
2. publicId の衝突再試行、フォロー、ミュート、関連一覧を実装する
3. R2 アバターの形式・容量検証、保存、削除、URL 解決を実装する
4. D1 / R2 bindings を使う結合テストと仕様を追加する

### Slice 3: #194 言葉・定義・いいね API

1. NFC 正規化、読みグループ、UUIDv7、cursor ヘルパーを TDD で実装する
2. 言葉の登録、一覧、取得、期限付き編集を実装する
3. 定義の作成、可視性、状態遷移、期限付き編集、論理削除を実装する
4. いいね、保存、関連一覧を冪等に実装する

### Slice 4: #193 辞書・タイムライン・検索 API

1. 合成 DTO の共通クエリを TDD で実装する
2. 自分・他者の辞書、定義、保存、ミュート一覧を実装する
3. 見つける、フォロー中、検索をミュート除外込みで実装する
4. keyset pagination の境界と主要クエリの `EXPLAIN QUERY PLAN` を検証する

### Slice 5: #195 物理削除 Cron・dev デプロイ・総合検証

1. 30 日保持後の物理削除を TDD で実装する
2. Wrangler の dev / prod D1・R2 bindings と手動デプロイコマンドを完成させる
3. dev リソースを作成し、マイグレーション、デプロイ、認証付きスモークテストを実行する
4. 全仕様、OpenAPI、DocBridge リンク、運用手順を同期する
5. 全検証後に本 plan を `doc/plans/done/` へ移動する

## テスト方針

- 各振る舞いは Red-Green-Refactor で実装し、実装前に期待理由で失敗することを確認する
- 純粋ロジックと SQLite 互換クエリは `bun test` を使う
- Workers bindings、Web Crypto、D1、R2、Scheduled Handler など Workerd 固有部分だけに Workers 結合テストを使う
- 認証は正常系に加え、署名、alg、kid、exp、iat、aud、iss、sub、鍵ローテーション、Cache-Control を網羅する
- 各 PR で server lint、typecheck、format check、test、OpenAPI 生成差分、DocBridge check を実行する

## 完了条件

- `server/openapi.json` にある全ルートが 501 を返さず、仕様どおり動作する
- Firebase ID トークンと App Check の欠落・不正を 401 で拒否する
- dev Workers 上で D1 読み書き、R2 アバター、認証、app-config、Scheduled Handler を検証できる
- prod の Worker、D1、R2 設定が検証済みで、デプロイだけが #186 に残っている
- 30 日保持後の物理削除が冪等に実行できる
- `doc/specs/workers-api-server.md` と主要実装が DocBridge で双方向リンクされている
- server lint、typecheck、format check、全テスト、OpenAPI 検証、DocBridge check がすべて通る
- #196、#192、#194、#193、#195 が完了し、#184 を閉じられる
