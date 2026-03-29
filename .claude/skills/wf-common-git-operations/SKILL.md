---
name: wf-common-git-operations
autoInvoke: when committing changes, creating branches, or checking for sensitive file leaks
description: ローカル Git 操作 — ブランチ作成、ステージング、コミット、セキュリティチェック、コミットメッセージ規約
---

# Git 操作

コミット品質のガードレール付きで、安全かつ一貫したローカル Git 操作を行う。

**基本原則:** プロジェクトルールが最優先。コミット前に検証。シークレットを絶対に漏らさない。

**開始時に宣言:** 「wf-common-git-operations スキルを使用して Git 操作を行います。」

## ルールの優先順位

1. プロジェクト固有ルール（プロジェクトの Skills / AGENTS / 既存ガイド）
2. このスキルの規約
3. 一般的な Git のベストプラクティス

迷った場合は、対象プロジェクトの Git 関連ルールを確認してから進める。

<!-- BRANCH_STRATEGY_SECTION -->

## ブランチ

既存のプロジェクト規約があればそれに従う。デフォルトの命名規則:

```
<type>/<task-id>-<short-kebab-summary>
```

タスク ID がない場合:

```
<type>/<yyyymmdd>-<short-kebab-summary>
```

ブランチの完了とマージオプションについては `wf-07-finishing-a-development-branch` に引き継ぐ。
独立したワークスペースが必要な場合は `wf-02-using-git-worktrees` を使用する。

## ステージング

- `git add .` より明示的な `git add <file>` を推奨する。
- `git add .` はユーザーが明示的に要求した場合にのみ使用する。
- コミット前に安全チェックリストを実行する: [references/safety-checklist.md](references/safety-checklist.md)

## コミットメッセージ

[references/commit-and-branch-rules.md](references/commit-and-branch-rules.md) の規約に従う。

デフォルトフォーマット: `[type]: [日本語の説明] [gitmoji]`

プロジェクト規約が異なる場合はそちらが優先。

### 禁止パターン

コミットメッセージに `@` の後に英数字が続くパターンを含めない。GitHub がユーザーメンションとして自動リンクし、通知が送信される。コミットメッセージではバッククォートのエスケープでも防げない。

検出した場合は `@` を除去する（例: `@param` → `param`）。

## コミット

1. ステージングを確認: `git status --short` と `git diff --staged`
2. 安全チェックリスト（シークレット、.gitignore）を実行
3. 規約に従ってコミットメッセージを作成
4. バリデーション: メッセージに `@` メンションがないこと
5. 実行: `git commit -m "<message>"`
6. pre-commit フックが失敗した場合: 修正、再ステージング、リトライ。`--no-verify` はユーザーの明示的な承認がある場合にのみ使用する。

## 報告

コミット後、以下を共有する:
- コミットハッシュ
- 変更ファイル
- 検証ステータス
- 残存する問題

## 例外処理

- **緊急のオーバーライド:** 理由を記録し、ユーザーの承認を得て、逸脱を記載する。
- **ルールの競合:** プロジェクト固有ルールが優先。判断理由を報告する。

## リファレンスファイル

- コミットとブランチの規約: [references/commit-and-branch-rules.md](references/commit-and-branch-rules.md)
- コミット前の安全チェックリスト: [references/safety-checklist.md](references/safety-checklist.md)

## 関連スキル

- `wf-07-finishing-a-development-branch` — ブランチの完了、マージ、クリーンアップ
- `wf-02-using-git-worktrees` — 並行作業のための独立ワークスペース
- `wf-common-collaborating-on-github` — GitHub 側の操作（Issue、PR）
