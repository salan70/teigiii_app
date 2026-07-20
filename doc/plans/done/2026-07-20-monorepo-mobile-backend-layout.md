# モノレポのルート構成を mobile_app / backend に整理する

> 注記: ディレクトリ再編に伴いパス表記を現行構成へ更新した（#230）。

Issue: #230

## 目的

ルート直下の Flutter プロジェクトと `server/` の非対称構成を解消し、モバイルアプリとバックエンドを対等なトップレベルプロジェクトとして分離する。ルートはモノレポ横断の入口・オーケストレーション層とする。

```text
.
├── mobile_app/   # Flutter（iOS / Android のみ）
├── backend/      # Cloudflare Workers API（旧 server/）
├── doc/          # 横断仕様・計画
├── nix/ flake.* justfile docbridge.config.json
└── .agents/ .claude/ .github/ .vscode/ AGENTS.md …
```

## 実行手順

1. Flutter 固有資産を `mobile_app/` へ `git mv` する
2. 未対応の `linux/`, `macos/`, `web/`, `windows/` を削除し、`.metadata` を iOS / Android のみに更新する
3. `packages/teigiii_api/` を `mobile_app/packages/teigiii_api/` へ `git mv` する
4. `server/` を `backend/` へ `git mv` し、private package 名を `teigiii-backend` に変更する
5. ルート `justfile` を横断コマンド（`setup` / `analyze` / `test` / `format`）+ `mobile-*` / `backend-*` 体系に再編する
6. DocBridge・GitHub Actions・VS Code・gitignore・iOS スクリプト等のパスを更新する
7. README / AGENTS / CLAUDE / specs / plans（done 含む）のパス参照を更新する
8. 残留参照を検索で確認し、検証コマンドを実行する

## 完了条件

- Git 管理された Flutter 固有資産が `mobile_app/`、Workers 固有資産が `backend/` に収まっている
- `linux/`, `macos/`, `web/`, `windows/` が存在せず、対応プラットフォームが iOS / Android のみ
- ルートにはモノレポ横断資産だけが残り、ルート自体は Flutter プロジェクトとして扱われない
- `server/`、旧 `server-*` コマンド、互換用 symlink / alias が残っていない
- ルートから `just setup`, `just analyze`, `just test`, `just format` を実行でき、両プロジェクトが対象になる
- `just generate-api` が `backend/openapi.json` → `mobile_app/packages/teigiii_api/` で動作する
- `just docbridge-check` が成功する
- モバイル・バックエンド・DocBridge 関連のパスが CI で整合している
- `git diff --check` が成功し、機能変更や一括フォーマットが含まれていない
