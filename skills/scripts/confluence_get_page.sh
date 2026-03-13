#!/usr/bin/env bash
set -euo pipefail

PAGE_ID="${1:-}"

if [[ -z "$PAGE_ID" ]]; then
  echo "Usage: confluence_get_page.sh <page_id>" >&2
  exit 1
fi

CONFLUENCE_BASE_URL_EFFECTIVE="${CONFLUENCE_BASE_URL:-${ATLASSIAN_BASE_URL:-}}"
CONFLUENCE_EMAIL_EFFECTIVE="${CONFLUENCE_EMAIL:-${ATLASSIAN_EMAIL:-}}"
CONFLUENCE_API_TOKEN_EFFECTIVE="${CONFLUENCE_API_TOKEN:-${ATLASSIAN_API_TOKEN:-}}"

if [[ -z "$CONFLUENCE_BASE_URL_EFFECTIVE" ]]; then
  echo "missing CONFLUENCE_BASE_URL (or ATLASSIAN_BASE_URL)" >&2
  exit 1
fi
if [[ -z "$CONFLUENCE_EMAIL_EFFECTIVE" ]]; then
  echo "missing CONFLUENCE_EMAIL (or ATLASSIAN_EMAIL)" >&2
  exit 1
fi
if [[ -z "$CONFLUENCE_API_TOKEN_EFFECTIVE" ]]; then
  echo "missing CONFLUENCE_API_TOKEN (or ATLASSIAN_API_TOKEN)" >&2
  exit 1
fi

URL="${CONFLUENCE_BASE_URL_EFFECTIVE%/}/wiki/rest/api/content/${PAGE_ID}?expand=body.storage,version,space"

curl -sS \
  -u "${CONFLUENCE_EMAIL_EFFECTIVE}:${CONFLUENCE_API_TOKEN_EFFECTIVE}" \
  -H "Accept: application/json" \
  "$URL"
