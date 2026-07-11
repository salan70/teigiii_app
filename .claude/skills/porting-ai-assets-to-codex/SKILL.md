---
name: porting-ai-assets-to-codex
description: Use when creating Codex-facing AI assets from Claude-facing skills, AGENTS instructions, hooks, or template guidance
---

# Codex 向け AI asset 移植

Claude 用 AI assets を元に、Codex 用 AI assets を symlink なしで作成・保守する。

## いつ使うか

- `.claude/skills/` に skill を追加・更新し、Codex 版も必要なとき
- `.agents/skills/` を Claude 正本から独立した実体として更新するとき
- `CLAUDE.md` の内容を元に `AGENTS.md` を作るとき
- Claude hooks や Claude 専用承認 UI の扱いを Codex 向けに整理するとき

## 原則

- `.claude` と `.agents` は別々の正本として扱う。
- symlink は使わない。
- コピーではなく移植を行う。
- Claude 専用の実行前提は Codex 側へそのまま持ち込まない。
- 片側専用にする判断は明示して記録する。

## 移植ワークフロー

1. 対象 asset を特定する。
2. Claude 固有前提を検出する。
3. Codex 側の対応に変換する。
4. 変換できないものを対象外または手動手順として記録する。
5. symlink ではなく実体ファイルとして配置する。
6. 検証コマンドを実行する。

## 変換ルール

| Claude 側 | Codex 側 |
|-----------|----------|
| `CLAUDE.md` | `AGENTS.md` |
| `.claude/skills/` | `.agents/skills/` |
| `ask_user_input` 前提 | 通常の会話確認、または利用可能な Codex 入力手段 |
| Task tool / Claude subagent 表現 | Codex のサブエージェント可用性に応じた表現 |
| `.claude/hooks/` | Codex では原則移植しない。必要なら手動手順化 |

## 検証

```bash
find templates/ai-driven-development -maxdepth 4 -type l -ls
rg -n "ask_user_input|Task tool|Claude Code|\\.claude/hooks|\\.agents/skills.*symlink|正本は `.claude`" templates/ai-driven-development/.agents templates/ai-driven-development/AGENTS.md
```

`find` は AI asset 関連 symlink がないことを確認する。`rg` は Codex 側に Claude 専用前提が残っていないことを確認する。
