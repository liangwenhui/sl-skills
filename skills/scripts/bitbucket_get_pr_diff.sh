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

BITBUCKET_USERNAME_EFFECTIVE="${BITBUCKET_USERNAME:-${ATLASSIAN_EMAIL:-}}"
BITBUCKET_APP_PASSWORD_EFFECTIVE="${BITBUCKET_APP_PASSWORD:-${ATLASSIAN_API_TOKEN:-}}"
BITBUCKET_API_BASE_URL_EFFECTIVE="${BITBUCKET_API_BASE_URL:-https://api.bitbucket.org/2.0}"

if [[ -z "$BITBUCKET_USERNAME_EFFECTIVE" ]]; then
  echo "missing BITBUCKET_USERNAME (or ATLASSIAN_EMAIL)" >&2
  exit 1
fi
if [[ -z "$BITBUCKET_APP_PASSWORD_EFFECTIVE" ]]; then
  echo "missing BITBUCKET_APP_PASSWORD (or ATLASSIAN_API_TOKEN)" >&2
  exit 1
fi

URL="${BITBUCKET_API_BASE_URL_EFFECTIVE%/}/repositories/${WORKSPACE}/${REPO_SLUG}/pullrequests/${PR_ID}/diff"

curl -sS \
  -u "${BITBUCKET_USERNAME_EFFECTIVE}:${BITBUCKET_APP_PASSWORD_EFFECTIVE}" \
  -H "Accept: text/plain" \
  "$URL"
