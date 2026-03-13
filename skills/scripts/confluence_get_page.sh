#!/usr/bin/env bash
set -euo pipefail

PAGE_ID="${1:-}"

if [[ -z "$PAGE_ID" ]]; then
  echo "Usage: confluence_get_page.sh <page_id>" >&2
  exit 1
fi

: "${ATLASSIAN_BASE_URL:?missing ATLASSIAN_BASE_URL}"
: "${ATLASSIAN_EMAIL:?missing ATLASSIAN_EMAIL}"
: "${ATLASSIAN_API_TOKEN:?missing ATLASSIAN_API_TOKEN}"

URL="${ATLASSIAN_BASE_URL%/}/wiki/rest/api/content/${PAGE_ID}?expand=body.storage,version,space"

curl -sS \
  -u "${ATLASSIAN_EMAIL}:${ATLASSIAN_API_TOKEN}" \
  -H "Accept: application/json" \
  "$URL"
