# CLAUDE.md

このファイルは Claude Code / Codex がこのリポジトリで作業する際のガイダンスを提供します。

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

`mobile_app/` / `backend/` 配下の作業では、各ディレクトリの CLAUDE.md も参照する。

## iOS 実機デバッグ（要約）

- iOS 26 実機の **無線 debug は LLDB 経由 JIT のため実用不可レベルに重い**（アプリ側の問題ではない）
- 実機 debug には `flutter config --enable-lldb-debugging` が必須
- 使い分け: シミュレータ debug / 実機 `--profile` / 実機 debug は USB。手順は `doc/ios-physical-device-debug.md`

## 指示の優先順位

1. **ユーザーの指示**（最優先） — 会話内での直接的な指示
2. **Skills** — Skill ツール経由で呼び出された場合
3. **CLAUDE.md のデフォルト**（最低） — このファイルに記載されたルール

## ワークフロー

すべての依頼に対し、該当する skill があれば使用する。
例外はユーザーが明示的にスキル不要と指示した場合のみ。
`mobile_app/` の UI 実装・変更は `implementing-ui-with-design-system` を必ず使用する。

## AI asset 運用

- Claude 用 assets: `.claude/` と `CLAUDE.md` / Codex 用 assets: `.agents/` と `AGENTS.md`
- `.agents` は `.claude` への symlink ではなく、独立した実体として管理する
- Claude 側の skill を追加・更新したら `porting-ai-assets-to-codex` で Codex 側への反映要否を判断する。移植の管理台帳は `doc/porting-ai-assets-to-codex.md`

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

- プロジェクトの CLAUDE.md や Skills で定義済みの手順をここに複製することを禁止する。スキルの内容を CLAUDE.md に転記せず、スキル名で参照すること。
- 依頼スコープ外の「ついでに改善」を禁止する。
- 将来の仮想要件に備えたコードを禁止する。

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

**MCP サーバー例**: github, mobile-mcp, pencil
