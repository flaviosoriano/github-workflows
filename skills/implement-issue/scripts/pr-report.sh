#!/usr/bin/env bash
# Usage: pr-report.sh <pr> [since-iso8601-utc]
# Prints what decides whether <pr> is ready to merge: head, merge state, checks,
# reviews and comments since <since>, and every unresolved review thread.
set -euo pipefail
pr=$1; since=${2:-1970-01-01T00:00:00Z}
repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
owner=${repo%/*}; name=${repo#*/}
me=$(gh api user --jq .login)

echo "## PR #$pr"
gh pr view "$pr" --json headRefOid,mergeable,mergeStateStatus,reviewDecision,isDraft,state \
  --jq '"head \(.headRefOid[0:7]) | state \(.state) | mergeable \(.mergeable) | mergeState \(.mergeStateStatus) | reviewDecision \(.reviewDecision // "-") | draft \(.isDraft)"'

echo; echo "## Checks"
gh pr checks "$pr" 2>&1 || true

echo; echo "## Reviews since $since"
gh api "repos/$repo/pulls/$pr/reviews" --paginate |
  jq -rs --arg s "$since" '.[][] | select(.submitted_at > $s) |
    "--- \(.user.login) \(.state) \(.submitted_at) commit \(.commit_id[0:7])\n\(.body | split("<!-- PULLFROG_DIVIDER")[0])\n"'

echo; echo "## Conversation comments since $since (excluding $me)"
gh api "repos/$repo/issues/$pr/comments" --paginate |
  jq -rs --arg s "$since" --arg me "$me" '.[][] | select(.created_at > $s and .user.login != $me) |
    "--- \(.user.login) \(.created_at)\n\(.body | split("<!-- PULLFROG_DIVIDER")[0])\n"'

echo; echo "## Unresolved review threads"
threads=$(gh api graphql -f owner="$owner" -f name="$name" -F pr="$pr" -f query='
  query($owner:String!, $name:String!, $pr:Int!) {
    repository(owner:$owner, name:$name) { pullRequest(number:$pr) {
      reviewThreads(first:100) { pageInfo { hasNextPage } nodes { id isResolved isOutdated path line
        comments(first:20) { pageInfo { hasNextPage } nodes { author { login } body } } } } } } }')
jq -r '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved | not) |
    "--- thread \(.id) \(.path):\(.line // "?")\(if .isOutdated then " (outdated)" else "" end)\n" +
    ([.comments.nodes[] | "[\(.author.login)] \(.body)"] | join("\n")) + "\n"' <<<"$threads"
if jq -e '.data.repository.pullRequest.reviewThreads | .pageInfo.hasNextPage or any(.nodes[]; .comments.pageInfo.hasNextPage)' <<<"$threads" >/dev/null; then
  echo "TRUNCATED: consulte as páginas restantes das threads ou comentários." >&2
  exit 1
fi
