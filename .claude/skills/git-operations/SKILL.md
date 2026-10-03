---
name: git-operations
description: ローカル Git の stage、commit、ブランチ変更、履歴統合に使う。
---

# Git 操作

プロジェクト固有ルールを優先し、無関係な dirty work を保持する。

## ブランチ戦略

プロジェクトの `AGENTS.md` や Git 運用文書に従う。
規約がなければ main への直接コミットを許可し、feature branch は任意とする。
保護ブランチが規約にあれば、commit 前に作業ブランチを作って変更を引き継ぐ。

## Stage・commit

- `git status --short` と差分で対象を確認し、`git add <明示パス>` で stage する。
  `git add .` はユーザーが明示した場合だけ使う。
- commit 前に `git diff --cached --check` と `--name-only` で、秘密情報やローカル生成物の混入を確認する。
  `.env*`、`*.pem`、`*.key`、`id_rsa*`、`*credentials*`、`service-account*.json` などは名前だけで断定せず、実データなら unstage して報告する。
- 関連検証が未実施なら実行する。
  同じ変更に対して成功済みなら、再実行は追加の変更や懸念がある場合に限る。
- commit やブランチ命名時は [コミットとブランチのルール](references/commit-and-branch-rules.md) を参照する。
- pre-commit 失敗時は原因を修正して再 stage する。
  `--no-verify` は明示承認がある場合だけ使う。

commit した場合は hash と push の有無を伝える。
