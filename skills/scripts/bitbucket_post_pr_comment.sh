#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not found in PATH" >&2
  exit 1
fi

WORKSPACE="${1:-}"
REPO_SLUG="${2:-}"
PR_ID="${3:-}"
COMMENT_FILE="${4:-}"

if [[ -z "$WORKSPACE" || -z "$REPO_SLUG" || -z "$PR_ID" || -z "$COMMENT_FILE" ]]; then
  echo "Usage: bitbucket_post_pr_comment.sh <workspace> <repo_slug> <pr_id> <comment_file>" >&2
  exit 1
fi

if [[ ! "$PR_ID" =~ ^[0-9]+$ ]]; then
  echo "Invalid pr_id: $PR_ID" >&2
  exit 1
fi

if [[ ! -f "$COMMENT_FILE" ]]; then
  echo "Comment file not found: $COMMENT_FILE" >&2
  exit 1
fi

BITBUCKET_USERNAME_EFFECTIVE="${BITBUCKET_USERNAME:-${ATLASSIAN_EMAIL:-}}"
BITBUCKET_TOKEN_EFFECTIVE="${BITBUCKET_TOKEN:-${BITBUCKET_APP_PASSWORD:-${ATLASSIAN_API_TOKEN:-}}}"

if [[ -z "$BITBUCKET_USERNAME_EFFECTIVE" ]]; then
  echo "missing BITBUCKET_USERNAME (or ATLASSIAN_EMAIL)" >&2
  exit 1
fi
if [[ -z "$BITBUCKET_TOKEN_EFFECTIVE" ]]; then
  echo "missing BITBUCKET_TOKEN (or BITBUCKET_APP_PASSWORD / ATLASSIAN_API_TOKEN)" >&2
  exit 1
fi

BITBUCKET_API_BASE_URL="https://api.bitbucket.org/2.0"
URL="${BITBUCKET_API_BASE_URL}/repositories/${WORKSPACE}/${REPO_SLUG}/pullrequests/${PR_ID}/comments"
PAYLOAD_FILE="$(mktemp)"

jq -n --arg raw "$(cat "$COMMENT_FILE")" '{content:{raw:$raw}}' > "$PAYLOAD_FILE"

curl -sS \
  -u "${BITBUCKET_USERNAME_EFFECTIVE}:${BITBUCKET_TOKEN_EFFECTIVE}" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X POST "$URL" \
  --data-binary "@$PAYLOAD_FILE"

rm -f "$PAYLOAD_FILE"
