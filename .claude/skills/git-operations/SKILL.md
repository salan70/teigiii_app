---
name: git-operations
description: ローカル Git の stage、commit、branch、履歴統合など、リポジトリを変更するときに使う。
---

# Git操作

プロジェクト固有ルールを先に確認し、無関係なdirty workを保持する。

<!-- BRANCH_STRATEGY_START -->
## 作業の開始

実装や修正を始める前に:

1. ベースブランチ（`main`、`develop` など）をプロジェクトルール、PR 情報、またはユーザー確認から特定する — 推測しない。
2. ベースブランチを同期する（**必須**）:
   ```bash
   git switch <base-branch>
   git pull --ff-only origin <base-branch>
   ```
3. 作業ブランチを作成する（**必須**）。ブランチ名は下記「ブランチ」セクションの命名規則に従う。

## 保護ブランチガード

コミット時に現在のブランチが保護ブランチ（main, master, develop）の場合:

1. ユーザーに確認せず、自動で作業ブランチを作成する
2. ブランチ名はコミット内容から自動生成する（命名規則に従う）
3. 作成したブランチに切り替えてからコミットする
4. 「保護ブランチ `<branch>` のため、`<new-branch>` を作成しました」と報告する

保護ブランチのデフォルトリストは `main, master, develop`。プロジェクトの CLAUDE.md で上書き可能。
<!-- BRANCH_STRATEGY_END -->

## ステージングと検証

1. `git status --short`と`git diff`で対象を確定する。
2. `git add <明示パス>`で関連ファイルだけをstageする。`git add .`はユーザーが明示した場合だけ使う。
3. commit 前は[安全チェックリスト](references/safety-checklist.md)を実行する。
4. 変更範囲に対応するプロジェクト指定の検証を実行する。
5. `git diff --cached --check`を実行する。

## コミット

- 規約: [コミットとブランチのルール](references/commit-and-branch-rules.md)
- pre-commit失敗時は原因を修正して再stageする。`--no-verify`は明示承認がある場合だけ使う。
- 完了時にcommit hash、変更ファイル、検証結果、push有無を報告する。
