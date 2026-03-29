# Issue / サブ Issue の管理手順

## 現状の確認

- `gh issue view <number> --comments`
- `gh api graphql` で `issue.id`、`parent`、`subIssues` を取得する（[gh-commands.md](gh-commands.md) を参照）。

## Issue の作成・更新

- 親 Issue: `gh issue create --title "<タイトル>" --body "<本文>"`
- 既存の更新: `gh issue edit <number> --title "<タイトル>" --body "<本文>"`
- 必要に応じてサブ Issue の候補を作成し、番号を控える。

## サブ Issue の親へのリンク

- `addSubIssue` ミューテーションを `gh api graphql` 経由で使用する。
- 既存の親から移動する場合は `replaceParent: true` を設定する。

## サブ Issue の整理

- **優先順位の変更:** `reprioritizeSubIssue` ミューテーション
- **リンク解除:** `removeSubIssue` ミューテーション
- 不要な Issue はクローズし、必要に応じて親にコメントで理由を記載する。

## 検証と共有

- GraphQL で親の `subIssues` リストを再取得し、構成が意図通りであることを確認する。
- 親 Issue に進捗コメントを投稿し、追加、削除、並び替えの概要を共有する。
