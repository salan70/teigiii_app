# Codex 向け AI asset 移植

スキル: porting-ai-assets-to-codex（Claude 側にのみ存在する。移植を実行するのは Claude 側のため）

初版: 2026-07-11 / 最終更新: 2026-07-27（#286）

## 位置づけ

`.claude/skills/` と `CLAUDE.md` を正本とし、Codex 用アセット `.agents/skills/` と `AGENTS.md` を実体ファイルとして管理する台帳。symlink は不使用。drift 防止は `porting-ai-assets-to-codex` を使う人手運用とする。

## Codex 側に置くスキル（9）

Codex で実際に使うものに限定する。Claude 側にあっても、ここに無いスキルは Codex へ移植しない。

| スキル | 適応内容 |
|---|---|
| git-operations | `variants/feature-branch.md` の保護ブランチ上書き参照を CLAUDE.md → AGENTS.md に変更 |
| collaborating-on-github | 変更なし |
| implementing-ui-with-design-system | Claude 固有ツール名（Glob / Grep）を CLI（`ls` / `rg`）に置換し、Cursor Cloud VM で Widgetbook / golden を実行できない場合の報告手順を追加 |
| test-driven-development | 変更なし |
| systematic-debugging | 変更なし |
| receiving-code-review | 禁止例の「明示的な CLAUDE.md 違反」を AGENTS.md に変更 |
| refactoring-code | 変更なし |
| docbridge-sync | 変更なし |
| docbridge-annotate | 変更なし |

## Claude 側のみに置くスキル

| スキル | 理由 |
|---|---|
| porting-ai-assets-to-codex | 移植の実行主体が Claude 側のため |
| syncing-ai-assets | `.claude/` への同期専用 |
| maintaining-ai-docs | AI ドキュメント保守は Claude 側で実施する |
| dispatching-parallel-agents | Claude のサブエージェント機構前提。Codex に同等機構なし |
| grilling | Codex では使用実績がない |
| docbridge-adopt / docbridge-link / docbridge-review | 導入・棚卸し系で、日常の Codex 作業では使わない |

## hooks の扱い

`.codex/hooks/` と `.codex/hooks.json` は DocBridge が生成する Codex 用フックであり、`.agents/skills/` とは別系統で管理する。`.codex/hooks.json` のコマンドは `git rev-parse --show-toplevel` 基準の可搬パスで記述する（#286）。

**Codex のツール契約は Claude Code と異なる**（codex-cli 0.144.6 の実セッションで確認）:

- ファイル編集の `tool_name` は `apply_patch`。`tool_input` に `file_path` は無く、パッチ本文が `command` に入る。1 回の呼び出しで複数ファイルを含みうる
- シェル実行の `tool_name` は `Bash`（Claude Code と同じ）
- そのため `post-tool-use-auto-format.sh` と `post-tool-use-docbridge-context.sh` は Claude 版と内容が異なる。パッチ本文の `*** Add File:` / `*** Update File:` / `*** Move to:` から対象パスを抽出する（削除は対象外）
- `stop-*` と `pre-tool-use-push-reminder.sh` は Claude 版と同一で動作する

`.codex/hooks.json` を変更すると `~/.codex/config.toml` の hook trust が失効し、フックが黙って実行されなくなる。変更後は対話セッションで trust を承認し直すこと。

## AGENTS.md の構成

プロジェクト CLAUDE.md を元に作成。変更点:

- 対象読者を Codex に変更
- 「AI asset 運用」セクションを追加（`.claude` / `.agents` の分離管理を明記）
- 指示の優先順位の「Skill ツール経由」を「`.agents/skills/` のスキル適用」に言い換え
- 禁止事項に「Claude 専用手順の転記禁止」を追加（正本 AGENTS.md に準拠）
- 完了報告フォーマットの MCP 例から pencil を除外（Claude 側の設定に紐づくため）
- Cursor Cloud VM 向けの注意点を末尾に記載

## 検証

- `find .agents AGENTS.md -maxdepth 4 -type l` → symlink が無いこと
- `rg -n '\.Codex|~/\.Codex' .agents/skills` → 機械置換由来の存在しないパス参照が無いこと
