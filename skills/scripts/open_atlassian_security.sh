#!/usr/bin/env bash
set -euo pipefail

URL="https://id.atlassian.com/manage-profile/security"

if command -v open >/dev/null 2>&1; then
  open "$URL"
  echo "Opened: $URL"
  exit 0
fi

if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$URL"
  echo "Opened: $URL"
  exit 0
fi

echo "Cannot auto-open browser. Please open manually: $URL" >&2
exit 1
