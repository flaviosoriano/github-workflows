#!/usr/bin/env bash
# Usage: wait-review.sh <pr> <since-iso8601-utc> [timeout-min=30]
# Waits until every Pullfrog run for <pr> started after <since> has finished.
# Exit codes: 0 runs finished; 1 a run failed; 2 timeout; 3 no run started within GRACE_SECONDS.
# Env: PULLFROG_WORKFLOW (default pullfrog.yml), GRACE_SECONDS (default 120).
set -euo pipefail
pr=$1; since=$2; timeout_min=${3:-30}
workflow=${PULLFROG_WORKFLOW:-pullfrog.yml}
grace=${GRACE_SECONDS:-120}
start=$(date +%s); settled=0
gh workflow view "$workflow" >/dev/null || { echo "ERROR: cannot inspect workflow $workflow" >&2; exit 1; }

while :; do
  elapsed=$(( $(date +%s) - start ))
  if (( elapsed > timeout_min * 60 )); then echo "TIMEOUT after ${timeout_min}min"; exit 2; fi

  runs=$(gh run list --workflow "$workflow" --limit 30 --json databaseId,displayTitle,status,conclusion,createdAt |
      jq --arg s "$since" --arg pr "$pr" '[.[] | select(.createdAt > $s) | select(.displayTitle | test("#" + $pr + "\\b"))]') || { echo "ERROR: cannot inspect runs" >&2; exit 1; }
  total=$(jq length <<<"$runs")
  pending=$(jq '[.[] | select(.status != "completed")] | length' <<<"$runs")
  failed=$(jq -r '.[] | select(.status == "completed" and .conclusion != "success") | "\(.databaseId) \(.conclusion) \(.displayTitle)"' <<<"$runs")

  if [[ -n $failed ]]; then echo "FAILED runs:"; echo "$failed"; exit 1; fi
  if (( total == 0 )); then
    if (( elapsed > grace )); then echo "NO_RUN: no review started for #$pr since $since"; exit 3; fi
  elif (( pending == 0 )); then
    # A push plus a mention can start a second run a few seconds later; wait for it to show up.
    settled=$((settled + 1))
    if (( settled >= 2 )); then echo "DONE: $total run(s) finished for #$pr"; exit 0; fi
  else
    settled=0
  fi
  sleep 30
done
