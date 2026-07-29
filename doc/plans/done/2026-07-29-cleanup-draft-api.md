# #252 Draft API / schema 掃除

## 目的

#248（破棄）検証で残った Dedicated Draft（`definition_drafts`）と、develop に残る未使用の `definitions.status=draft` 経路を削除し、Draft 非採用（#187）と整合させる。

## 調査結果

| 対象 | 状態 |
| --- | --- |
| `/v1/definition-drafts*` / `definition_drafts` テーブル（#248） | develop のコード・migration には無い（未マージ）。`teigiii-api-dev` へ deploy 済みの可能性あり |
| `definitions.status='draft'` / `draftCount` / `?status=draft` | develop に残存。モバイルは public/private のみ作成・更新しており未使用 |
| 本番 D1 | #248 は deploy していない想定。Firebase 移行データにも draft は無い |

## 方針

1. **コード**: `draft` ステータスと `draftCount` を API / schema / service / OpenAPI / テストから削除。定義は `public` / `private` のみ
2. **migration**: draft 定義行を物理削除 → `definitions` を `public|private` + `finalized_at NOT NULL` に再構築 → `DROP TABLE IF EXISTS definition_drafts`（#248 残骸掃除）
3. **残データ**:
   - **dev**: draft 行・`definition_drafts` は検証用なので破棄してよい
   - **prod**: 残骸は想定外。migration は no-op 相当（DROP IF EXISTS / draft 0 件）で安全に適用

## 実行手順

1. 失敗するテストへ更新（draft 作成・遷移・一覧・draftCount を削除／拒否）
2. schema / service / routes / OpenAPI を更新
3. drizzle migration を生成・手直し
4. 仕様（`workers-api-server.md`、IA の Draft 参照）を更新
5. `just backend-generate` / `just backend-analyze` / `just backend-test`
6. 必要なら `just generate-api` で Dart クライアント同期

## 完了条件

- [x] Draft 専用 route / `definition_drafts` 参照が develop に無い（確認済みを維持）
- [x] `definitions.status` に `draft` が無い
- [x] OpenAPI・ユニット / Worker テストが緑
- [x] 本番/dev 残データの扱いが PR / 本 plan に明記されている
- [x] closes #252
