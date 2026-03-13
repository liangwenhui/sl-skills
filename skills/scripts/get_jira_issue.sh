#!/usr/bin/env bash
set -euo pipefail

ISSUE_KEY="${1:-}"
FIELDS="${2:-summary,status,assignee,priority,issuetype,reporter,created,updated,description,comment}"

if [[ -z "$ISSUE_KEY" ]]; then
  echo "Usage: get_jira_issue.sh ISSUE-123 [fields]" >&2
  exit 1
fi

if [[ ! "$ISSUE_KEY" =~ ^[A-Z][A-Z0-9]+-[0-9]+$ ]]; then
  echo "Invalid issue key format: $ISSUE_KEY" >&2
  exit 1
fi

: "${JIRA_BASE_URL:?missing JIRA_BASE_URL}"
: "${JIRA_EMAIL:?missing JIRA_EMAIL}"
: "${JIRA_API_TOKEN:?missing JIRA_API_TOKEN}"

URL="${JIRA_BASE_URL%/}/rest/api/3/issue/${ISSUE_KEY}?fields=${FIELDS}"

curl -sS \
  -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -H "Accept: application/json" \
  "$URL"
