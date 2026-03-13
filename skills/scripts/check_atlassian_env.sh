#!/usr/bin/env bash
# Check if Atlassian environment variables are configured.
# Returns 0 if all required vars are set, non-zero otherwise.

ENV_FILE="$HOME/.atlassian_env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$ENV_FILE"
fi

BASE_URL="${ATLASSIAN_BASE_URL:-}"
EMAIL="${ATLASSIAN_EMAIL:-}"
TOKEN="${ATLASSIAN_API_TOKEN:-}"

if [[ -z "$BASE_URL" || -z "$EMAIL" || -z "$TOKEN" ]]; then
  echo "ATLASSIAN_* not configured"
  exit 1
fi

echo "ATLASSIAN_* configured"
exit 0
