#!/usr/bin/env bash
set -euo pipefail

PAGE_ID="${1:-}"

if [[ -z "$PAGE_ID" ]]; then
  echo "Usage: confluence_get_page.sh <page_id>" >&2
  exit 1
fi

: "${CONFLUENCE_BASE_URL:?missing CONFLUENCE_BASE_URL}"
: "${CONFLUENCE_EMAIL:?missing CONFLUENCE_EMAIL}"
: "${CONFLUENCE_API_TOKEN:?missing CONFLUENCE_API_TOKEN}"

URL="${CONFLUENCE_BASE_URL%/}/wiki/rest/api/content/${PAGE_ID}?expand=body.storage,version,space"

curl -sS \
  -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
  -H "Accept: application/json" \
  "$URL"
