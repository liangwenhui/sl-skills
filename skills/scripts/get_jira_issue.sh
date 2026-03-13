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

JIRA_BASE_URL_EFFECTIVE="${JIRA_BASE_URL:-${ATLASSIAN_BASE_URL:-}}"
JIRA_EMAIL_EFFECTIVE="${JIRA_EMAIL:-${ATLASSIAN_EMAIL:-}}"
JIRA_API_TOKEN_EFFECTIVE="${JIRA_API_TOKEN:-${ATLASSIAN_API_TOKEN:-}}"

if [[ -z "$JIRA_BASE_URL_EFFECTIVE" ]]; then
  echo "missing JIRA_BASE_URL (or ATLASSIAN_BASE_URL)" >&2
  exit 1
fi
if [[ -z "$JIRA_EMAIL_EFFECTIVE" ]]; then
  echo "missing JIRA_EMAIL (or ATLASSIAN_EMAIL)" >&2
  exit 1
fi
if [[ -z "$JIRA_API_TOKEN_EFFECTIVE" ]]; then
  echo "missing JIRA_API_TOKEN (or ATLASSIAN_API_TOKEN)" >&2
  exit 1
fi

URL="${JIRA_BASE_URL_EFFECTIVE%/}/rest/api/3/issue/${ISSUE_KEY}?fields=${FIELDS}"

curl -sS \
  -u "${JIRA_EMAIL_EFFECTIVE}:${JIRA_API_TOKEN_EFFECTIVE}" \
  -H "Accept: application/json" \
  "$URL"
