#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="$HOME/.atlassian_env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$ENV_FILE"
fi

BASE_URL="${1:-${ATLASSIAN_BASE_URL:-}}"
EMAIL="${2:-${ATLASSIAN_EMAIL:-}}"
TOKEN="${3:-${ATLASSIAN_API_TOKEN:-}}"
BITBUCKET_TOKEN_VALUE="${4:-${BITBUCKET_TOKEN:-${BITBUCKET_APP_PASSWORD:-}}}"

if [[ -z "$BASE_URL" || -z "$EMAIL" || -z "$TOKEN" ]]; then
  echo "Usage: setup_atlassian_env.sh <base_url> <email> <api_token> [bitbucket_token]" >&2
  echo "Or provide ATLASSIAN_BASE_URL/ATLASSIAN_EMAIL/ATLASSIAN_API_TOKEN in env." >&2
  exit 1
fi

# Persist credentials to a dedicated env file with strict permissions.
umask 077
{
  printf 'export ATLASSIAN_BASE_URL=%q\n' "$BASE_URL"
  printf 'export ATLASSIAN_EMAIL=%q\n' "$EMAIL"
  printf 'export ATLASSIAN_API_TOKEN=%q\n' "$TOKEN"
  if [[ -n "$BITBUCKET_TOKEN_VALUE" ]]; then
    printf 'export BITBUCKET_TOKEN=%q\n' "$BITBUCKET_TOKEN_VALUE"
    printf 'export BITBUCKET_APP_PASSWORD=%q\n' "$BITBUCKET_TOKEN_VALUE"
  fi
} > "$ENV_FILE"
chmod 600 "$ENV_FILE"

if [[ "${SHELL:-}" == *"zsh"* ]]; then
  RC_FILE="$HOME/.zshrc"
else
  RC_FILE="$HOME/.bashrc"
fi

SOURCE_LINE='[ -f "$HOME/.atlassian_env" ] && source "$HOME/.atlassian_env"'
if [[ -f "$RC_FILE" ]]; then
  if ! grep -Fqx "$SOURCE_LINE" "$RC_FILE"; then
    printf '\n%s\n' "$SOURCE_LINE" >> "$RC_FILE"
  fi
else
  printf '%s\n' "$SOURCE_LINE" > "$RC_FILE"
fi

export ATLASSIAN_BASE_URL="$BASE_URL"
export ATLASSIAN_EMAIL="$EMAIL"
export ATLASSIAN_API_TOKEN="$TOKEN"
if [[ -n "$BITBUCKET_TOKEN_VALUE" ]]; then
  export BITBUCKET_TOKEN="$BITBUCKET_TOKEN_VALUE"
  export BITBUCKET_APP_PASSWORD="$BITBUCKET_TOKEN_VALUE"
fi

echo "Persisted ATLASSIAN_* to $ENV_FILE"
if [[ -n "$BITBUCKET_TOKEN_VALUE" ]]; then
  echo "Persisted BITBUCKET_TOKEN to $ENV_FILE"
fi
echo "Ensured source line exists in $RC_FILE"
echo "Current shell session is ready."
