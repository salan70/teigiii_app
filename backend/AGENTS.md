# backend/AGENTS.md

Cloudflare Workers API の作業ガイド。ルートの `AGENTS.md` を前提とし、ここには `backend/` 固有の要点のみ書く。

## 構成の要点

- Hono + Drizzle + D1 / R2。エントリは `src/index.ts`、ルート定義は `src/routes/`
- HTTP のフィールド・ステータスの正本は `openapi.json`（`src/routes/` から生成する）
- 認証・認可・可視性・状態遷移・並び順の正本は `doc/specs/workers-api-server.md`。API を追加・変更する前に読む
- 全エンドポイントが Firebase App Check トークン必須のため、生 curl での動作確認は 401 になる。機能検証はテストで行う

## 検証

- 変更後は `just check-changed` を実行する。`backend/` の変更では format、lint、型検査、テストが走る。全体は `just check`。
- `check` に含まれないもの: スキーマ（`src/db/`）とルート（`src/routes/`）を変えたときの `just backend-generate`。
- macOS では `backend/test/schema.test.ts` が 13 件落ちる既知の失敗がある（#328）。CI（Linux）では通る。macOS で `just check-changed` を通すときは `TEIGIII_SKIP_STEPS=backend-test` を付け、`bun run test:workers` を別に実行する。

ローカル起動は `just backend-dev`（:8787、D1 / R2 は Miniflare のローカルエミュレーション）。
