---
name: wf-02-using-git-worktrees
description: 現在のワークスペースから隔離が必要な機能開発の開始時、または実装計画の実行前に使用 — スマートなディレクトリ選択と安全性検証で隔離された Git worktree を作成する
---

# Git Worktree の使い方

## 概要

Git worktree は同じリポジトリを共有する隔離されたワークスペースを作成し、切り替えなしで複数のブランチを同時に作業できるようにします。

**基本原則:** 体系的なディレクトリ選択 + 安全性検証 = 確実な隔離。

**開始時に宣言:** 「wf-02-using-git-worktrees スキルを使って隔離されたワークスペースを構築します。」

## ディレクトリ選択プロセス

以下の優先順位に従ってください:

### 1. 既存ディレクトリの確認

```bash
# 優先順位で確認
ls -d .worktrees 2>/dev/null     # 推奨（隠しディレクトリ）
ls -d worktrees 2>/dev/null      # 代替
```

**見つかった場合:** そのディレクトリを使用。両方存在する場合は `.worktrees` を優先。

### 2. CLAUDE.md の確認

```bash
grep -i "worktree.*director" CLAUDE.md 2>/dev/null
```

**設定がある場合:** 確認せずにその設定を使用。

### 3. ユーザーに確認

ディレクトリが存在せず CLAUDE.md にも設定がない場合:

```
worktree ディレクトリが見つかりません。どこに作成しますか？

1. .worktrees/ (プロジェクトローカル、隠しディレクトリ)
2. ~/.config/superpowers/worktrees/<project-name>/ (グローバルな場所)

どちらにしますか？
```

## 安全性の検証

### プロジェクトローカルのディレクトリ (.worktrees または worktrees)

**worktree 作成前にディレクトリが無視されているか必ず確認:**

```bash
# ディレクトリが無視されているか確認（ローカル、グローバル、システムの gitignore を考慮）
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**無視されていない場合:**

「壊れているものは即座に直す」ルールに従い:
1. .gitignore に適切な行を追加
2. 変更をコミット
3. worktree の作成に進む

**なぜ重要か:** worktree の内容が誤ってリポジトリにコミットされることを防ぎます。

### グローバルディレクトリ (~/.config/superpowers/worktrees)

プロジェクト外にあるため .gitignore の検証は不要。

## 作成手順

### 1. プロジェクト名の検出

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. Worktree の作成

```bash
# フルパスを決定
case $LOCATION in
  .worktrees|worktrees)
    path="$LOCATION/$BRANCH_NAME"
    ;;
  ~/.config/superpowers/worktrees/*)
    path="~/.config/superpowers/worktrees/$project/$BRANCH_NAME"
    ;;
esac

# 新しいブランチで worktree を作成
git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

### 3. プロジェクトセットアップの実行

自動検出して適切なセットアップを実行:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

### 4. クリーンなベースラインの確認

worktree がクリーンな状態で開始することをテストで確認:

```bash
# 例 — プロジェクトに適したコマンドを使用
npm test
cargo test
pytest
go test ./...
```

**テストが失敗した場合:** 失敗を報告し、続行するか調査するか確認。

**テストが通った場合:** 準備完了を報告。

### 5. 場所の報告

```
Worktree の準備完了: <full-path>
テスト通過 (<N> テスト、0 失敗)
<feature-name> の実装準備完了
```

## クイックリファレンス

| 状況 | アクション |
|------|-----------|
| `.worktrees/` が存在 | 使用する（無視されているか検証） |
| `worktrees/` が存在 | 使用する（無視されているか検証） |
| 両方が存在 | `.worktrees/` を使用 |
| どちらも存在しない | CLAUDE.md を確認 → ユーザーに確認 |
| ディレクトリが無視されていない | .gitignore に追加 + コミット |
| テストがベースラインで失敗 | 失敗を報告 + 確認 |
| package.json/Cargo.toml がない | 依存関係のインストールをスキップ |

## よくあるミス

### 無視検証のスキップ

- **問題:** worktree の内容が追跡され、git status を汚染
- **対策:** プロジェクトローカルの worktree 作成前は必ず `git check-ignore` を実行

### ディレクトリの場所を決め打ち

- **問題:** 一貫性がなくなり、プロジェクトの慣例に違反
- **対策:** 優先順位に従う: 既存 > CLAUDE.md > 確認

### テスト失敗のまま続行

- **問題:** 新しいバグと既存の問題を区別できない
- **対策:** 失敗を報告し、続行の明示的な許可を得る

### セットアップコマンドのハードコーディング

- **問題:** 異なるツールを使うプロジェクトで壊れる
- **対策:** プロジェクトファイル（package.json 等）から自動検出

## ワークフロー例

```
あなた: wf-02-using-git-worktrees スキルを使って隔離されたワークスペースを構築します。

[.worktrees/ を確認 — 存在する]
[無視を検証 — git check-ignore で .worktrees/ が無視されていることを確認]
[worktree 作成: git worktree add .worktrees/auth -b feature/auth]
[npm install を実行]
[npm test を実行 — 47 テスト通過]

Worktree の準備完了: /Users/jesse/myproject/.worktrees/auth
テスト通過 (47 テスト、0 失敗)
auth 機能の実装準備完了
```

## 危険信号

**絶対にしないこと:**
- 無視されているか検証せずに worktree を作成（プロジェクトローカルの場合）
- ベースラインのテスト検証をスキップ
- テスト失敗のまま確認なしに続行
- 曖昧な場合にディレクトリの場所を決め打ち
- CLAUDE.md の確認をスキップ

**必ず行うこと:**
- ディレクトリ優先順位に従う: 既存 > CLAUDE.md > 確認
- プロジェクトローカルの場合はディレクトリが無視されているか検証
- プロジェクトセットアップを自動検出・実行
- クリーンなテストベースラインを検証

## 連携

**呼び出し元:**
- **wf-01-brainstorming** (フェーズ 4) — 設計承認後に実装へ進む場合に必須
- **wf-04-subagent-driven-development** — タスク実行前に必須
- **wf-04-executing-plans** — タスク実行前に必須
- 隔離されたワークスペースが必要なすべてのスキル

**セットで使用:**
- **wf-07-finishing-a-development-branch** — 作業完了後のクリーンアップに必須
