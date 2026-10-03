# AGENTS.md

このファイルは Claude Code / Codex / Cursor がこのリポジトリで作業する際のガイダンスを提供します。
`CLAUDE.md` は置きません。

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

## 参照地図

| ドキュメント | いつ読むか |
| --- | --- |
| `doc/architecture.md` | `mobile_app/` のレイヤー配置を判断する前 |
| `doc/specs/README.md` | 仕様の一覧と位置づけを確認する（個別仕様はここから辿る） |
| `doc/specs/mobile-app-design-system.md` | Ds コンポーネント・トークンを扱う前 |
| `doc/specs/workers-api-server.md` | backend の API を追加・変更する前 |
| `doc/ios-physical-device-debug.md` | iOS 実機で動作確認する前 |

`mobile_app/` / `backend/` 配下の作業では、各ディレクトリの AGENTS.md も参照する。

## iOS 実機デバッグ（要約）

- iOS 26 実機の **無線 debug は LLDB 経由 JIT のため実用不可レベルに重い**（アプリ側の問題ではない）
- 実機 debug には `flutter config --enable-lldb-debugging` が必須
- 使い分け: シミュレータ debug / 実機 `--profile` / 実機 debug は USB。手順は `doc/ios-physical-device-debug.md`

## 指示の優先順位

1. **ユーザーの指示**（最優先） — 会話内での直接的な指示
2. **Skills** — `.claude/skills/` のスキルを適用する場合
3. **AGENTS.md のデフォルト**（最低） — このファイルに記載されたルール

## ワークフロー

すべての依頼に対し、該当する skill があれば使用する。
例外はユーザーが明示的にスキル不要と指示した場合のみ。
`mobile_app/` の UI 実装・変更は `implementing-ui-with-design-system` を必ず使用する。

## AI asset 運用

- 指示の正本はこのファイル。Skill は `.claude/skills/` に置き、Codex と Cursor は `.agents/skills -> ../.claude/skills` で同じものを読む
- 共通 Skill（`git-operations`、`collaborating-on-github`、`verifying-environment`）の正本は dotfiles の `ai-assets/skills/` で、dotfiles の `infra/ai/sync-ai-assets.sh` で上書き配備する。直接編集しない
- 共通の指示に Claude 専用のツール名を書かない
- エージェント向けの hook は置かない。共通の検査は `.githooks/pre-commit`（DocBridge のリンク検査、対応先とデバッグコードの報告）と CI が担う。clone 後に `just install-git-hooks` を 1 回実行する
- `docbridge` Skill は DocBridge が管理する。版を上げたら `bunx docbridge@<版> upgrade --force` で入れ替える

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

## Git 運用

- **1 Issue = 1 ブランチ = 1 PR** の原則を守る
- すべての作業は Issue を起点として開始する。Issue なしでの直接コミットは原則禁止
- PR 本文に `closes #<issue-number>` を含めて Issue を自動クローズする
- ベースブランチは `develop`。保護ブランチは `main` / `develop`

## 完了条件

実装依頼では、依頼範囲の変更と関連検証まで続けます。
将来の変更で参照する設計判断は、必要に応じて `doc/` の設計文書または plan へ残します。
適用、merge、未依頼の外部操作は自動実行しません。

## 文章規範

- 結論と必要な行動を先に書き、前置き、賛辞、定型の報告枠を使わない。
- 承認依頼、失敗、未完了、破壊的操作の予告は必ず明示する。
- 静的な Markdown は 1 文 1 行で書く。Issue、PR、コメント、回答は段落内で改行しない。
- 日本語と英数字やインラインコードの間には半角スペースを入れる。全角括弧の内外には入れない。

## Cursor Cloud specific instructions

Cursor Cloud の VM 向けの非自明な注意点のみを記載する。標準コマンドは `justfile` を参照。

### ツールチェーン
- Cloud VM では Nix を使わない（`flake.nix` はローカル / CI 用）。`bun` / `flutter` 3.41.8 / `dart` / `just` は snapshot に導入済みで `/usr/local/bin` から解決できる。
- 依存の更新は起動時の update script（`bun install --frozen-lockfile` + `flutter pub get`）で自動実行される。`just setup` を再実行する必要は通常ない。

### mobile_app/.env（重要）
- `mobile_app/.env` は `*.env` として git-ignore されるが、`pubspec.yaml` の必須アセットであり、無いと `flutter test` / `flutter build` が "No file or variants found for asset: .env" で失敗する。
- update script が未存在時に AdMob テスト広告 ID 入りで自動生成する。CI はコメント行だけの非空プレースホルダを置く（完全な空ファイルだと `dotenv.load()` が `EmptyEnvFileError` で落ちる）。

### backend（Cloudflare Workers API）
- `just backend-dev`（= `wrangler dev`）は :8787 で起動し、D1 / R2 は Miniflare のローカルエミュレーションで自動供給される。外部 DB は不要。
- 全エンドポイントが Firebase App Check トークン必須の設計のため、有効な Firebase トークンなしの生 curl は `GET /v1/app-config` を含め 401 (`app_check_invalid`) になる。API のコア機能検証は `just backend-test`（unit + `@cloudflare/vitest-pool-workers` の統合テスト、mock verifier を注入）で行う。

### mobile_app（Flutter）
- Android SDK / エミュレータ / iOS シミュレータ / 実機がなく、実 Firebase も必要なため、Cloud VM では `flutter run` による対話起動は不可。headless では lint / test / codegen のみ実施できる。
- 生成コード（`*.g.dart` / `*.freezed.dart` / `*.gr.dart`）はコミット済み。CI は build_runner を実行しないため、`just analyze` / `just test` 前に `just mobile-generate` は必須ではない（`.dart` を変更・追加した場合のみ再生成する）。
