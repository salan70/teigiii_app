---
name: collaborating-on-github
description: gh CLI で Issue・PR・レビュー・CI を確認、更新するときに使う。
---

# GitHub での協業

GitHub 操作は `gh`、ローカル操作は `git` を使う。
文面はプロジェクト慣例がなければ日本語にする。
投稿、状態変更、push、Resolve、merge は依頼範囲に含まれる場合だけ行う。
merge にはユーザーの明示承認が必要。

## 対象とレビュー

- 番号だけが指定された場合は、remote の Issue と PR を照合して種別を確定する。
- PR 作業では `gh pr view <number> --json baseRefName,headRefName,headRefOid,state,isDraft` で対象を確認する。
- レビュー対応では REST comments と GraphQL `reviewThreads` の両方を取得する。
- 読み取り、修正、返信、Resolve の対象 head を揃える。
  head が変わったら差分とレビューを再確認する。
- 修正が必要な thread は、検証した変更を commit・push してから返信・Resolve する。
  完了判断には最新の未解決 thread、CI、review decision、merge state、PR body を使う。

## PR・Issue の更新

- 新規 PR は作業と検証が未完なら Draft とし、完了済みならプロジェクト慣例に従う。
- 進捗共有を依頼された場合は、状態変更、blocker、仕様変更、レビュー完了を簡潔に記録する。
  短い内部作業の逐次コメントは投稿しない。
- 本文は先頭段落に結論を書き、テンプレートの見出しは変えない。
  レビューへの返信は対応内容と未対応の理由だけを書く。
- sub-issue や review thread の操作時は [非自明な gh コマンド](references/gh-commands.md) を参照する。

外部操作が失敗した場合は、未完了の操作と再開条件を伝える。
