#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="$HOME/.atlassian_env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$ENV_FILE"
fi

current_base_url="${ATLASSIAN_BASE_URL:-}"
current_email="${ATLASSIAN_EMAIL:-}"
current_api_token="${ATLASSIAN_API_TOKEN:-}"
current_bitbucket_token="${BITBUCKET_TOKEN:-${BITBUCKET_APP_PASSWORD:-}}"

script_dir="$(cd "$(dirname "$0")" && pwd)"

prompt_with_default() {
  local label="$1"
  local current="$2"
  local value

  if [[ -n "$current" ]]; then
    read -r -p "$label [$current]: " value
  else
    read -r -p "$label: " value
  fi

  if [[ -z "$value" ]]; then
    value="$current"
  fi

  printf '%s' "$value"
}

prompt_secret_with_default() {
  local label="$1"
  local current="$2"
  local value

  if [[ -n "$current" ]]; then
    read -r -s -p "$label [********]: " value
  else
    read -r -s -p "$label: " value
  fi
  echo

  if [[ -z "$value" ]]; then
    value="$current"
  fi

  printf '%s' "$value"
}

while true; do
  new_base_url="$(prompt_with_default "ATLASSIAN_BASE_URL" "$current_base_url")"
  [[ -n "$new_base_url" ]] && break
  echo "ATLASSIAN_BASE_URL is required."
done

while true; do
  new_email="$(prompt_with_default "ATLASSIAN_EMAIL" "$current_email")"
  [[ -n "$new_email" ]] && break
  echo "ATLASSIAN_EMAIL is required."
done

while true; do
  new_api_token="$(prompt_secret_with_default "ATLASSIAN_API_TOKEN" "$current_api_token")"
  if [[ -n "$new_api_token" ]]; then
    break
  fi

  echo "ATLASSIAN_API_TOKEN is required. Opening Atlassian security page..."
  "$script_dir/open_atlassian_security.sh" >/dev/null 2>&1 || true
  echo "After creating token, paste it here."
done

new_bitbucket_token="$(prompt_secret_with_default "BITBUCKET_TOKEN (optional)" "$current_bitbucket_token")"

"$script_dir/setup_atlassian_env.sh" "$new_base_url" "$new_email" "$new_api_token" "$new_bitbucket_token"

echo "Config reset complete."
echo "- ATLASSIAN_BASE_URL: updated"
echo "- ATLASSIAN_EMAIL: updated"
if [[ -n "$new_bitbucket_token" ]]; then
  echo "- BITBUCKET_TOKEN: updated"
else
  echo "- BITBUCKET_TOKEN: empty"
fi
