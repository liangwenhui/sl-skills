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

show_plain_value() {
  local value="$1"
  if [[ -n "$value" ]]; then
    printf '%s' "$value"
  else
    printf '<empty>'
  fi
}

show_secret_status() {
  local value="$1"
  if [[ -n "$value" ]]; then
    printf '<set>'
  else
    printf '<empty>'
  fi
}

prompt_plain_value() {
  local label="$1"
  local value
  while true; do
    read -r -p "New $label: " value
    if [[ -n "$value" ]]; then
      printf '%s' "$value"
      return
    fi
    echo "$label cannot be empty."
  done
}

prompt_secret_value() {
  local label="$1"
  local value
  while true; do
    read -r -s -p "New $label: " value
    echo
    if [[ -n "$value" ]]; then
      printf '%s' "$value"
      return
    fi
    echo "$label cannot be empty."
  done
}

new_base_url="$current_base_url"
new_email="$current_email"
new_api_token="$current_api_token"
new_bitbucket_token="$current_bitbucket_token"

echo "Select config key to update:"
echo "0) Save and exit"
echo "1) ATLASSIAN_BASE_URL"
echo "2) ATLASSIAN_EMAIL"
echo "3) ATLASSIAN_API_TOKEN"
echo "4) BITBUCKET_TOKEN"
echo "5) Clear BITBUCKET_TOKEN"

while true; do
  echo
  echo "Current values:"
  echo "- ATLASSIAN_BASE_URL: $(show_plain_value "$new_base_url")"
  echo "- ATLASSIAN_EMAIL: $(show_plain_value "$new_email")"
  echo "- ATLASSIAN_API_TOKEN: $(show_secret_status "$new_api_token")"
  echo "- BITBUCKET_TOKEN: $(show_secret_status "$new_bitbucket_token")"
  read -r -p "Choose option [0-5]: " choice

  case "$choice" in
    1)
      new_base_url="$(prompt_plain_value "ATLASSIAN_BASE_URL")"
      ;;
    2)
      new_email="$(prompt_plain_value "ATLASSIAN_EMAIL")"
      ;;
    3)
      new_api_token="$(prompt_secret_value "ATLASSIAN_API_TOKEN")"
      ;;
    4)
      new_bitbucket_token="$(prompt_secret_value "BITBUCKET_TOKEN")"
      ;;
    5)
      new_bitbucket_token=""
      echo "BITBUCKET_TOKEN cleared."
      ;;
    0)
      if [[ -z "$new_base_url" ]]; then
        echo "ATLASSIAN_BASE_URL is required. Please update option 1."
        continue
      fi
      if [[ -z "$new_email" ]]; then
        echo "ATLASSIAN_EMAIL is required. Please update option 2."
        continue
      fi
      if [[ -z "$new_api_token" ]]; then
        echo "ATLASSIAN_API_TOKEN is required. Opening Atlassian security page..."
        "$script_dir/open_atlassian_security.sh" >/dev/null 2>&1 || true
        echo "Please update option 3 after creating token."
        continue
      fi
      break
      ;;
    *)
      echo "Invalid option. Please enter 0, 1, 2, 3, 4, or 5."
      ;;
  esac
done

"$script_dir/setup_atlassian_env.sh" "$new_base_url" "$new_email" "$new_api_token" "$new_bitbucket_token"

echo "Config reset complete."
if [[ "$new_base_url" != "$current_base_url" ]]; then
  echo "- ATLASSIAN_BASE_URL: updated"
else
  echo "- ATLASSIAN_BASE_URL: unchanged"
fi
if [[ "$new_email" != "$current_email" ]]; then
  echo "- ATLASSIAN_EMAIL: updated"
else
  echo "- ATLASSIAN_EMAIL: unchanged"
fi
if [[ "$new_api_token" != "$current_api_token" ]]; then
  echo "- ATLASSIAN_API_TOKEN: updated"
else
  echo "- ATLASSIAN_API_TOKEN: unchanged"
fi
if [[ "$new_bitbucket_token" != "$current_bitbucket_token" ]]; then
  if [[ -n "$new_bitbucket_token" ]]; then
    echo "- BITBUCKET_TOKEN: updated"
  else
    echo "- BITBUCKET_TOKEN: cleared"
  fi
else
  if [[ -n "$new_bitbucket_token" ]]; then
    echo "- BITBUCKET_TOKEN: unchanged"
  else
    echo "- BITBUCKET_TOKEN: empty"
  fi
fi
