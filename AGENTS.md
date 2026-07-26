# AGENTS.md

このファイルは Codex がこのリポジトリで作業する際のガイダンスを提供します。

## プロジェクト概要

モノレポ構成の teigiii プロジェクト。

- `mobile_app/` — Flutter/Dart アプリ（teigi_app、iOS / Android）
- `backend/` — Cloudflare Workers API
- ルート — Nix / Just / DocBridge / CI / AI assets など横断オーケストレーション

**技術スタック**:
- Flutter（Nix flake でバージョン管理）
- Riverpod（状態管理）
- Freezed（コード生成）
- auto_route（ルーティング）
- Cloudflare Workers + Hono + Drizzle + D1（backend）

**対象**: 個人開発者（1 人で開発するプロジェクト向け）

**ブランチ戦略**: develop ブランチをメインブランチとして運用

## クイックリファレンス

```bash
# 開発環境セットアップ（mobile_app + backend）
just setup

# コード生成（Freezed等・モバイル）
just mobile-generate

# Lint（両プロジェクト）
just analyze

# Format（両プロジェクト）
just format

# テスト（両プロジェクト）
just test

# iOS 実機（iOS 26）: 日常はシミュレータ、実機確認は profile。詳細は doc/ios-physical-device-debug.md
flutter config --enable-lldb-debugging
just mobile-run-dev-profile-on <device-id>
```

## iOS 実機デバッグ（要約）

- iOS 26 実機の **無線 debug は LLDB 経由 JIT のため実用不可レベルに重い**（アプリ側の問題ではない）
- 実機 debug には `flutter config --enable-lldb-debugging` が必須
- 使い分け: シミュレータ debug / 実機 `--profile` / 実機 debug は USB。手順は `doc/ios-physical-device-debug.md`

## AI asset 運用

- Claude 用 assets: `.claude/` と `CLAUDE.md`
- Codex 用 assets: `.agents/` と `AGENTS.md`
- `.agents` は `.claude` への symlink ではなく、独立した実体として管理する
- Claude 側に skill を追加・更新した場合は `porting-ai-assets-to-codex` を使って Codex 側への移植要否を判断する

## 指示の優先順位

1. **ユーザーの指示**（最優先） — 会話内での直接的な指示
2. **Skills** — `.agents/skills/` のスキルを適用する場合
3. **AGENTS.md のデフォルト**（最低） — このファイルに記載されたルール

## ワークフロー

すべての依頼に対し、`.agents/skills/` に該当する skill があれば使用する。
例外はユーザーが明示的にスキル不要と指示した場合のみ。
`mobile_app/` の UI 実装・変更は `implementing-ui-with-design-system` を必ず使用する。

## plan ワークフロー

- 計画は `doc/plans/YYYY-MM-DD-{slug}.md` に置く。**目的・実行手順・完了条件**を含めること（固定テンプレはなし）
- 実行完了後、その plan ファイルを `doc/plans/done/` へ移動してコミットする
- plan を伴わない作業の判断記録はコミットメッセージ / PR に書く。長期的に参照する判断のみ `doc/` に置く

## 対話原則

- 共感は一切不要。正しさと合理性を重視すること。
- お世辞・同意の前置き・感情的な共感表現を避け、結論と根拠を直接示す。
- ユーザーの主張に誤りや論理的破綻があれば、忖度せず率直に指摘する。
- 不確実な事項は推測で断定せず、確認手段または根拠を提示する。

## 禁止事項

- プロジェクトの AGENTS.md や Skills で定義済みの手順をここに複製することを禁止する。スキルの内容を AGENTS.md に転記せず、スキル名で参照すること。
- 依頼スコープ外の「ついでに改善」を禁止する。
- 将来の仮想要件に備えたコードを禁止する。
- Claude 専用の手順を Codex 用 asset にそのまま転記することを禁止する。

## 完了報告フォーマット（必須）

**すべての作業完了時**、以下のフォーマットで報告すること:

```markdown
## 作業完了報告

### 実施内容
- {作業内容を箇条書き}

### 変更ファイル
- {主要な変更ファイル}

### 使用したツール
**Skills**: {使用したスキル名。なければ「なし」}
**MCP**: {使用した MCP サーバー名。なければ「なし」}

### 次のアクション
- {コミット要否、確認依頼など}
```

**MCP サーバー例**: github, mobile-mcp

## Cursor Cloud specific instructions

Cursor Cloud の VM 向けの非自明な注意点のみを記載する。標準コマンドは `justfile` を参照。

### ツールチェーン
- Cloud VM では Nix を使わない（`flake.nix` はローカル / CI 用）。`bun` / `flutter` 3.41.8 / `dart` / `just` は snapshot に導入済みで `/usr/local/bin` から解決できる。
- 依存の更新は起動時の update script（`bun install --frozen-lockfile` + `flutter pub get`）で自動実行される。`just setup` を再実行する必要は通常ない。

### mobile_app/.env（重要）
- `mobile_app/.env` は `*.env` として git-ignore されるが、`pubspec.yaml` の必須アセットであり、無いと `flutter test` / `flutter build` が "No file or variants found for asset: .env" で失敗する。
- update script が未存在時に AdMob テスト広告 ID 入りで自動生成する。CI は空ファイル（`touch mobile_app/.env`）で十分。

### backend（Cloudflare Workers API）
- `just backend-dev`（= `wrangler dev`）は :8787 で起動し、D1 / R2 は Miniflare のローカルエミュレーションで自動供給される。外部 DB は不要。
- 全エンドポイントが Firebase App Check トークン必須の設計のため、有効な Firebase トークンなしの生 curl は `GET /v1/app-config` を含め 401 (`app_check_invalid`) になる。API のコア機能検証は `just backend-test`（unit + `@cloudflare/vitest-pool-workers` の統合テスト、mock verifier を注入）で行う。

### mobile_app（Flutter）
- Android SDK / エミュレータ / iOS シミュレータ / 実機がなく、実 Firebase も必要なため、Cloud VM では `flutter run` による対話起動は不可。headless では lint / test / codegen のみ実施できる。
- 生成コード（`*.g.dart` / `*.freezed.dart` / `*.gr.dart`）はコミット済み。CI は build_runner を実行しないため、`just analyze` / `just test` 前に `just mobile-generate` は必須ではない（`.dart` を変更・追加した場合のみ再生成する）。
