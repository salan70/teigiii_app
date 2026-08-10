# backend prod deploy を安全に再開できるようにする（#322）

## 目的

prod Worker が develop から乖離したまま deploy できない状態を解消し、次のストア配信（v1.2.1+11 以降）の
前提を整える。本 plan のスコープは **コード / 設定 / 手順の整備と PR まで**で、実際の prod migrate / deploy は
`backend-guard-prod` が `origin/develop` 一致を要求するため merge 後に別途実施する。

## 互換性の実測

v1.2.1+11 タグの `backend/openapi.json` と現行 develop の差分を突き合わせた結果:

| スキーマ | 差分 | 配信済み v1.2.1 への影響 |
| --- | --- | --- |
| `DefinedWordItem` | `draftCount` 削除 / `readingSubGroup` 追加 | **破壊的**（必須キー欠落） |
| `MyDictionaryOverview` | `draftCount` 削除 | **破壊的** |
| `AppConfigResponse` / `SavedWordItem` / `UserDictionaryItem` | プロパティ追加のみ | 影響なし |
| `UpdateDefinitionRequest` | `wordId` 削除 | 影響なし |
| パス | `/v1/words/lookup`・`/v1/telemetry/frames` 追加のみ | 影響なし |

追加プロパティが安全なのは、生成クライアントが `$checkKeys(requiredKeys:)` しか検査せず未知キーを無視するため。
リクエスト側の `wordId` 削除が安全なのは、zod が非 strict で未知キーを strip するため。

→ **互換シムが必要なのは `draftCount` の 2 箇所だけ。**

## 実行手順

1. `draftCount` 互換シムを `backend/src/compat/draft-count-shim.ts` に置き、HTTP 境界（`routes/me.ts`）で適用する。
   OpenAPI 契約には載せない（`openapi.json` は無変更）
2. prod 運用 recipe を justfile に追加する
   - `backend-app-config-prod` / `backend-seed-prod` / `backend-set-min-app-version-prod`
   - `backend-bookmark-prod` / `backend-restore-prod`（D1 Time Travel）
   - `backend-drift-check`（prod と `origin/develop` の乖離検査）
   - `backend-deploy-prod` に `--var DEPLOYED_SHA:$(git rev-parse HEAD)` を追加
3. `backend/wrangler.toml` の `[env.prod.vars]` に `WEB_QA_PAGES_PROJECT = ""` を置き、vars 継承警告を消す
4. `doc/specs/workers-api-server.md` の prod 手順を更新する
5. 各テスト（compat / justfile / cors）を追加する

## 設計判断

### 互換シムを OpenAPI 契約に戻さない

スキーマに戻すと `mobile_app/packages/teigiii_api` の再生成が必要になる。さらに必須で戻すと、シム撤去時に
「その時点の配信済みアプリ」を再び壊す。optional で戻しても新クライアントに不要なフィールドが残る。
`OpenAPIHono` はレスポンスを検証しないため、シムは wire レベルで完結でき、撤去は 1 ファイル削除で済む。

### ドリフト検知は「deploy 時に SHA をスタンプし、読み取り recipe で照合する」

`wrangler deployments list` の時刻比較は乖離を推測できるだけで、prod に出ている commit を特定できない。
`backend-guard-prod` が `HEAD == origin/develop` を保証しているため、deploy 時に `--var DEPLOYED_SHA` を
打てば、その値がそのまま「prod に出ている develop の commit」になる。

定期通知（Cron / Slack）は #291 のリリース回帰検知 Cron に相乗りさせる方針とし、本 Issue では実装しない。
単独の Cron を先に建てると、#291 側で `controller.cron` の dispatch 設計をやり直すことになるため。

### migration の順序

`0003` / `0004` は 2 件とも旧 Worker のまま先に適用してよい（Issue #322 に判断根拠を記載）。
壊れるのは migration ではなく Worker deploy によるレスポンス形状の変更であり、シムがそれを吸収する。
順序は `bookmark → migrate → 互換シム入り Worker を deploy`。

## 完了条件

- [ ] `draftCount` 互換シムが入り、v1.2.1 の `requiredKeys` を満たすことが worker-test で固定されている
- [ ] `openapi.json` に差分が出ていない
- [ ] Time Travel によるバックアップ / 復旧手順が `doc/specs/workers-api-server.md` の prod 手順に含まれている
- [ ] prod `app_config` を確認・更新する recipe が存在する
- [ ] `just backend-drift-check` が prod と `origin/develop` の乖離を検出できる
- [ ] prod ドリフト検知の自動化方針が記録されている
- [ ] `just backend-analyze` / `just backend-test` / `just backend-validate-prod` / `just docbridge-check` が通る

## スコープ外（merge 後に別途実施）

- prod の migrate / deploy / smoke test
- dev Worker のドリフト解消（本 PR が `backend/**` を触るため、develop への merge で CI の `deploy-dev` が走り自動解消する）
- 互換シムの撤去（`min_app_version_*` 引き上げ後に別 Issue）
