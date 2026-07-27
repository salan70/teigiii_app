---
name: collaborating-on-github
description: GitHub CLI で Issue・PR・コメントを操作する。Issue の作成や確認、PR の作成・更新、進捗共有を行う時に使用する（レビュー指摘への対応は receiving-code-review）。
---

# GitHub での協業

`gh` CLI を使用して GitHub の Issue、Pull Request、進捗コミュニケーションを最小限のセレモニーで管理する。

**基本原則:** GitHub 操作はすべて `gh` で行う。関係者への情報共有を怠らない。まず Draft、検証後に Ready。

**開始時に宣言:** 「collaborating-on-github スキルを使用して GitHub 操作を行います。」

## ルールの優先順位

1. プロジェクト固有ルール（プロジェクトの Skills / AGENTS / 既存ガイド）
2. このスキルの規約
3. 一般的な GitHub のベストプラクティス

## 基本方針

- GitHub 操作はすべて `gh` CLI を使用し、ローカル Git 操作には `git` を使用する。
- コメントの言語はデフォルトで日本語。プロジェクトの慣例がある場合はそちらに従う。
- PR はデフォルトで **Draft** として作成し、セルフレビューと検証の後に `gh pr ready <number>` で Ready にする。
- レビューフィードバックへの対応は `receiving-code-review` に引き継ぐ。

## Pull Request ワークフロー

### PR の作成

1. Draft として作成: `gh pr create --draft --title "<タイトル>" --body "<本文>"`
2. Draft 状態でセルフレビューと検証を完了する。
3. レビュー準備ができたら: `gh pr ready <number>`

### レビューの投稿

指摘は本文にまとめず、該当行にインラインコメントとして付ける。レビュー本文とインラインを 1 リクエストで投稿する手順、行指定（`line` / `start_line` / `side`）、インラインを付けられないケースの扱いは [references/gh-commands.md](references/gh-commands.md) を参照。

### 作業前の同期

PR 関連の作業を始める前に、ベースブランチを同期する:

```bash
base_branch="$(gh pr view <number> --json baseRefName --jq -r '.baseRefName')"
head_branch="$(gh pr view <number> --json headRefName --jq -r '.headRefName')"

git switch "$base_branch"
git pull --ff-only origin "$base_branch"
git switch "$head_branch"
```

`main` や `develop` をハードコードしない — 必ず PR の `baseRefName` から読み取る。

## Issue とサブ Issue の管理

作業を親 Issue（ゴール＋受け入れ基準）とサブ Issue（実行可能なタスク）に分割する。

- `addSubIssue` GraphQL ミューテーションでサブ Issue を親に追加する。
- サブ Issue の順序は優先度を反映させる。
- 完了済みまたは不要なサブ Issue はクローズまたはリンク解除する。
- スコープが拡大したり議論が分岐した場合は、新しいサブ Issue を作成する。

詳細な手順: [references/issue-management.md](references/issue-management.md)

## 進捗コメント

以下の場合に Issue/PR にコメントを投稿する:

- ブロッカーに遭遇した場合
- 仕様や方針の変更が発生した場合
- レビューの依頼やレビュー対応が完了した場合

短い内部タスクに対するノイジーな更新は避ける。テンプレートは [references/comment-templates.md](references/comment-templates.md) を使用する。

## 失敗時のフォールバック

API 呼び出しが失敗した場合（権限、ネットワーク、予期しない状態）:

1. 無言で続行しない。
2. 失敗の詳細と影響を PR/Issue にコメントする。
3. 明確な次のステップ（例: 権限の付与、リトライ条件）とともにブロッカーをユーザーに報告する。

## コマンドリファレンス

- 主要コマンド: [references/gh-commands.md](references/gh-commands.md)
- Issue/サブ Issue の手順: [references/issue-management.md](references/issue-management.md)
- コメントテンプレート: [references/comment-templates.md](references/comment-templates.md)

## 関連スキル

- `receiving-code-review` — レビューフィードバックへの対応
- `git-operations` — ローカル Git 操作（ブランチ、コミット、安全確認）
