---
name: collaborating-on-github
description: PR のレビュー対応と sub-issue の操作で gh の GraphQL が要るときに使う。
---

# GitHub のレビュー対応

branch、commit、PR の作成、merge の規則は `.claude/rules/pstack.md` に従う。ここには `gh` の使い方だけを置く。

## 対象の確認

- 番号だけが指定された場合は、remote の Issue と PR を照合して種別を確定する。
- PR 作業では `gh pr view <number> --json baseRefName,headRefName,headRefOid,state,isDraft` で対象を確認する。

## レビュー対応

- REST の comments と GraphQL の `reviewThreads` の両方を取得する。
- 読み取り、修正、返信、Resolve の対象 head を揃える。
  head が変わったら差分とレビューを再確認する。
- 修正が必要な thread は、検証した変更を commit・push してから返信・Resolve する。
  完了判断には最新の未解決 thread、CI、review decision、merge state、PR body を使う。
- 返信は対応内容と未対応の理由だけを書く。

thread の返信・Resolve と sub-issue の接続は [非自明な gh コマンド](references/gh-commands.md) を参照する。
