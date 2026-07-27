# backend/CLAUDE.md

Cloudflare Workers API の作業ガイド。ルートの `CLAUDE.md` を前提とし、ここには `backend/` 固有の要点のみ書く。

## 構成の要点

- Hono + Drizzle + D1 / R2。エントリは `src/index.ts`、ルート定義は `src/routes/`
- HTTP のフィールド・ステータスの正本は `openapi.json`（`src/routes/` から生成する）
- 認証・認可・可視性・状態遷移・並び順の正本は `doc/specs/workers-api-server.md`。API を追加・変更する前に読む
- 全エンドポイントが Firebase App Check トークン必須のため、生 curl での動作確認は 401 になる。機能検証はテストで行う

## 検証コマンドの選択規則

| 変更内容 | 実行するコマンド |
| --- | --- |
| 常に | `just backend-analyze` / `just backend-test` |
| スキーマ（`src/db/`）・ルート（`src/routes/`）の変更 | `just backend-generate` |
| 仕様（`doc/specs/`）と紐づくコードの変更 | `just docbridge-check` |

ローカル起動は `just backend-dev`（:8787、D1 / R2 は Miniflare のローカルエミュレーション）。
