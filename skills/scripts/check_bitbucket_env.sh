#!/usr/bin/env bash
set -euo pipefail
# Check if Bitbucket environment variables are configured.
# Returns 0 if required vars are set, non-zero otherwise.

ENV_FILE="$HOME/.atlassian_env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$ENV_FILE"
fi

EMAIL="${ATLASSIAN_EMAIL:-}"
BITBUCKET_TOKEN="${BITBUCKET_TOKEN:-${BITBUCKET_APP_PASSWORD:-${ATLASSIAN_API_TOKEN:-}}}"

if [[ -z "$EMAIL" || -z "$BITBUCKET_TOKEN" ]]; then
  echo "BITBUCKET_* not configured"
  exit 1
fi

echo "BITBUCKET_* configured"
exit 0
