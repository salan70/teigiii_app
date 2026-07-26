#!/usr/bin/env bash
# Cloudflare Pages の preview branch / alias 用にブランチ名を正規化する。
# Pages は alias サブドメインを 28 文字に切るため、こちらでも先に揃える。

sanitize_pages_branch() {
  local raw="${1:-preview}"
  local branch
  branch="$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"
  if [[ -z "$branch" ]]; then
    branch="preview"
  fi
  # Cloudflare Pages preview alias 上限（実測: 28）
  branch="${branch:0:28}"
  branch="${branch%-}"
  if [[ -z "$branch" ]]; then
    branch="preview"
  fi
  printf '%s' "$branch"
}
