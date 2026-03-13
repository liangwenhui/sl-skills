#!/usr/bin/env bash
set -euo pipefail

# Requires jq for JSON creation/parsing.
if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not found in PATH" >&2
  exit 1
fi

MODE="${1:-}"
if [[ -z "$MODE" ]]; then
  echo "Usage:" >&2
  echo "  confluence_write_page.sh create <space_key> <title> <body_file>" >&2
  echo "  confluence_write_page.sh update <page_id> <title_or_dash> <body_file>" >&2
  exit 1
fi

: "${CONFLUENCE_BASE_URL:?missing CONFLUENCE_BASE_URL}"
: "${CONFLUENCE_EMAIL:?missing CONFLUENCE_EMAIL}"
: "${CONFLUENCE_API_TOKEN:?missing CONFLUENCE_API_TOKEN}"

BASE="${CONFLUENCE_BASE_URL%/}"
API="${BASE}/wiki/rest/api/content"

api_call() {
  local method="$1"
  local url="$2"
  local data_file="${3:-}"

  if [[ -n "$data_file" ]]; then
    curl -sS -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X "$method" "$url" \
      --data-binary "@$data_file"
  else
    curl -sS -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
      -H "Accept: application/json" \
      -X "$method" "$url"
  fi
}

case "$MODE" in
  create)
    SPACE_KEY="${2:-}"
    TITLE="${3:-}"
    BODY_FILE="${4:-}"
    if [[ -z "$SPACE_KEY" || -z "$TITLE" || -z "$BODY_FILE" ]]; then
      echo "Usage: confluence_write_page.sh create <space_key> <title> <body_file>" >&2
      exit 1
    fi
    if [[ ! -f "$BODY_FILE" ]]; then
      echo "Body file not found: $BODY_FILE" >&2
      exit 1
    fi

    TMP_JSON="$(mktemp)"
    jq -n \
      --arg t "$TITLE" \
      --arg s "$SPACE_KEY" \
      --arg v "$(cat "$BODY_FILE")" \
      '{type:"page", title:$t, space:{key:$s}, body:{storage:{value:$v,representation:"storage"}}}' > "$TMP_JSON"
    api_call POST "$API" "$TMP_JSON"
    rm -f "$TMP_JSON"
    ;;

  update)
    PAGE_ID="${2:-}"
    TITLE_OR_DASH="${3:-}"
    BODY_FILE="${4:-}"
    if [[ -z "$PAGE_ID" || -z "$TITLE_OR_DASH" || -z "$BODY_FILE" ]]; then
      echo "Usage: confluence_write_page.sh update <page_id> <title_or_dash> <body_file>" >&2
      exit 1
    fi
    if [[ ! -f "$BODY_FILE" ]]; then
      echo "Body file not found: $BODY_FILE" >&2
      exit 1
    fi

    CURRENT="$(api_call GET "${API}/${PAGE_ID}?expand=version,title")"
    CURRENT_VERSION="$(echo "$CURRENT" | jq -r '.version.number')"
    CURRENT_TITLE="$(echo "$CURRENT" | jq -r '.title')"

    if [[ "$CURRENT_VERSION" == "null" || -z "$CURRENT_VERSION" ]]; then
      echo "Failed to read current page version for page: $PAGE_ID" >&2
      exit 1
    fi

    NEW_TITLE="$CURRENT_TITLE"
    if [[ "$TITLE_OR_DASH" != "-" ]]; then
      NEW_TITLE="$TITLE_OR_DASH"
    fi

    NEXT_VERSION=$((CURRENT_VERSION + 1))

    TMP_JSON="$(mktemp)"
    jq -n \
      --arg id "$PAGE_ID" \
      --arg t "$NEW_TITLE" \
      --arg v "$(cat "$BODY_FILE")" \
      --argjson n "$NEXT_VERSION" \
      '{id:$id, type:"page", title:$t, version:{number:$n}, body:{storage:{value:$v,representation:"storage"}}}' > "$TMP_JSON"

    api_call PUT "${API}/${PAGE_ID}" "$TMP_JSON"
    rm -f "$TMP_JSON"
    ;;

  *)
    echo "Usage:" >&2
    echo "  confluence_write_page.sh create <space_key> <title> <body_file>" >&2
    echo "  confluence_write_page.sh update <page_id> <title_or_dash> <body_file>" >&2
    exit 1
    ;;
esac
