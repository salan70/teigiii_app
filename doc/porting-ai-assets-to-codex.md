# Codex 向け AI asset 移植

日付: 2026-07-11
スキル: porting-ai-assets-to-codex

## 実施内容

`.claude/skills/`（13 スキル）と `CLAUDE.md` を元に、Codex 用アセット `.agents/skills/`（10 スキル）と `AGENTS.md` を実体ファイルとして新規作成した。symlink は不使用。

## 移植したスキル（10）

| スキル | 適応内容 |
|---|---|
| grilling | 変更なし（Claude 固有前提なし） |
| collaborating-on-github | 変更なし |
| test-driven-development | 変更なし |
| refactoring-code | 変更なし |
| systematic-debugging | 変更なし |
| maintaining-ai-docs | 変更なし（CLAUDE.md への言及は文書保守対象としての記載であり実行前提ではない） |
| git-operations | `variants/feature-branch.md` の保護ブランチ上書き参照を CLAUDE.md → AGENTS.md に変更 |
| receiving-code-review | 禁止例の「明示的な CLAUDE.md 違反」を AGENTS.md に変更 |
| managing-agent-memory | 廃止済みスキル `wf-08-reflecting-on-sessions` への連携参照を汎用表現に変更 |
| porting-ai-assets-to-codex | 正本 dotfiles の Codex 版（`.agents/skills/` 版）を採用し、検証コマンドのパスを本プロジェクト（`.agents` / `AGENTS.md`）に適応 |

## Claude 専用として除外したスキル（3）

| スキル | 除外理由 |
|---|---|
| continuous-learning | Claude の Stop フック（`stop-instinct-collect.sh`）と `~/.claude/instincts/` に依存。Codex に同等のフック機構なし |
| syncing-ai-assets | `.claude/` への同期専用スキル。Codex 側の同期は porting-ai-assets-to-codex が担当 |
| dispatching-parallel-agents | `Task()`（Claude サブエージェント）前提。Codex に同等の並列サブエージェント機構なし |

## hooks の扱い

`.claude/hooks/`（auto-format、push リマインダー、デバッグコード検出等）は変換ルールに従い Codex へ移植しない。同等の品質担保が必要な場合は手動実行:

- フォーマット: `fvm dart format .`
- Lint: `fvm flutter analyze`
- デバッグコード確認: コミット前に `print(` / `debugPrint(` の残存を目視確認

## AGENTS.md の構成

プロジェクト CLAUDE.md を元に作成。変更点:

- 対象読者を Codex に変更
- 「AI asset 運用」セクションを追加（`.claude` / `.agents` の分離管理を明記）
- 指示の優先順位の「Skill ツール経由」を「`.agents/skills/` のスキル適用」に言い換え
- 禁止事項に「Claude 専用手順の転記禁止」を追加（正本 AGENTS.md に準拠）
- 完了報告フォーマットの MCP 例から pencil を除外（Claude 側の設定に紐づくため）

## 検証結果

- `find .agents AGENTS.md -maxdepth 4 -type l` → symlink なし
- Claude 固有前提パターン（ask_user_input / Task tool / Claude Code / .claude/hooks）の残存は porting-ai-assets-to-codex 自身の変換ルール表のみ（正本 Codex 版と同一の設計上の記載）
