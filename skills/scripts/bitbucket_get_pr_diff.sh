#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${1:-}"
REPO_SLUG="${2:-}"
PR_ID="${3:-}"

if [[ -z "$WORKSPACE" || -z "$REPO_SLUG" || -z "$PR_ID" ]]; then
  echo "Usage: bitbucket_get_pr_diff.sh <workspace> <repo_slug> <pr_id>" >&2
  exit 1
fi

if [[ ! "$PR_ID" =~ ^[0-9]+$ ]]; then
  echo "Invalid pr_id: $PR_ID" >&2
  exit 1
fi

: "${BITBUCKET_USERNAME:?missing BITBUCKET_USERNAME}"
: "${BITBUCKET_APP_PASSWORD:?missing BITBUCKET_APP_PASSWORD}"
BITBUCKET_API_BASE_URL="${BITBUCKET_API_BASE_URL:-https://api.bitbucket.org/2.0}"

URL="${BITBUCKET_API_BASE_URL%/}/repositories/${WORKSPACE}/${REPO_SLUG}/pullrequests/${PR_ID}/diff"

curl -sS \
  -u "${BITBUCKET_USERNAME}:${BITBUCKET_APP_PASSWORD}" \
  -H "Accept: text/plain" \
  "$URL"
