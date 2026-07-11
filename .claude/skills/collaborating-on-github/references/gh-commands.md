# gh コマンド

## Issue

```bash
gh issue list
gh issue view <number>
gh issue view <number> --comments
gh issue create --title "<タイトル>" --body "<本文>"
gh issue edit <number> --title "<タイトル>" --body "<本文>"
gh issue comment <number> --body "<コメント>"
```

## Issue / サブ Issue（GraphQL）

```bash
# 親子関係の取得（issue.id、parent、subIssues）
gh api graphql -f query='
query($owner:String!, $repo:String!, $number:Int!) {
  repository(owner:$owner, name:$repo) {
    issue(number:$number) {
      id
      number
      title
      url
      parent { id number title url }
      subIssues(first:100) {
        nodes { id number title url state }
      }
    }
  }
}' -F owner="<owner>" -F repo="<repo>" -F number="<issue-number>"

# サブ Issue の追加（既存 Issue を親にリンク）
gh api graphql -f query='
mutation($issueId: ID!, $subIssueId: ID!) {
  addSubIssue(input: {issueId: $issueId, subIssueId: $subIssueId}) {
    issue { id number url }
    subIssue { id number url }
  }
}' -F issueId="<parent-issue-id>" -F subIssueId="<sub-issue-id>"

# 既存の親から別の親に移動
gh api graphql -f query='
mutation($issueId: ID!, $subIssueId: ID!, $replaceParent: Boolean!) {
  addSubIssue(input: {issueId: $issueId, subIssueId: $subIssueId, replaceParent: $replaceParent}) {
    issue { id number url }
    subIssue { id number url }
  }
}' -F issueId="<parent-issue-id>" -F subIssueId="<sub-issue-id>" -F replaceParent=true

# サブ Issue の優先順位変更（before/after で位置指定）
gh api graphql -f query='
mutation($issueId: ID!, $subIssueId: ID!, $beforeId: ID) {
  reprioritizeSubIssue(input: {issueId: $issueId, subIssueId: $subIssueId, beforeId: $beforeId}) {
    issue { id number url }
  }
}' -F issueId="<parent-issue-id>" -F subIssueId="<sub-issue-id>" -F beforeId="<target-sub-issue-id>"

# サブ Issue のリンク解除
gh api graphql -f query='
mutation($issueId: ID!, $subIssueId: ID!) {
  removeSubIssue(input: {issueId: $issueId, subIssueId: $subIssueId}) {
    issue { id number url }
    subIssue { id number url }
  }
}' -F issueId="<parent-issue-id>" -F subIssueId="<sub-issue-id>"
```

## Pull Request

```bash
# PR は Draft で作成し、検証後に Ready にする
gh pr list
gh pr view <number>
gh pr view <number> --comments
gh pr view <number> --json title,reviewDecision,mergeStateStatus,url
gh pr create --draft --title "<タイトル>" --body "<本文>"
gh pr comment <number> --body "<コメント>"
gh pr edit <number> --title "<タイトル>" --body "<本文>"
gh pr ready <number>
gh pr merge <number>
```

## ベース/ヘッドの同期

```bash
# PR からベース/ヘッドブランチ名を取得
base_branch="$(gh pr view <number> --json baseRefName --jq -r '.baseRefName')"
head_branch="$(gh pr view <number> --json headRefName --jq -r '.headRefName')"

# 作業開始前にベースブランチを同期
git switch "$base_branch"
git pull --ff-only origin "$base_branch"

# ヘッドブランチに戻って作業
git switch "$head_branch"
```

## レビューコメント / スレッド

```bash
# PR のレビューコメント一覧
gh api "repos/<owner>/<repo>/pulls/<number>/comments" --paginate

# レビュースレッド一覧（comment-id / thread-id のマッピング）
gh api graphql -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          comments(first: 100) {
            nodes {
              id
              databaseId
              url
            }
          }
        }
      }
    }
  }
}' -F owner="<owner>" -F repo="<repo>" -F number="<number>"

# 特定のコメントに返信
gh api -X POST "repos/<owner>/<repo>/pulls/<number>/comments/<comment-id>/replies" -f body="<返信本文>"

# レビュースレッドを解決
gh api graphql -f query='
mutation($threadId: ID!) {
  resolveReviewThread(input: {threadId: $threadId}) {
    thread {
      id
      isResolved
    }
  }
}' -F threadId="<thread-id>"

# 未解決スレッド数の確認
gh api graphql -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          isResolved
        }
      }
    }
  }
}' -F owner="<owner>" -F repo="<repo>" -F number="<number>" \
  --jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'
```

## CI / ワークフロー

```bash
gh run list
gh run view <run-id>
gh workflow run <workflow-name>
```
