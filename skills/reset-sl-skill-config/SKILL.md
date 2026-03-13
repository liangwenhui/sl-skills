---
name: reset-sl-skill-config
description: Reset sl-skill Atlassian configuration interactively. Use when user wants to update or reconfigure ATLASSIAN_BASE_URL, ATLASSIAN_EMAIL, ATLASSIAN_API_TOKEN, or BITBUCKET_TOKEN by selecting config keys from a menu.
---

# Reset SL Skill Config

## Goal
重新设置 `sl-skills` 配置，通过菜单选择要修改的 key。

## Managed Config
- `ATLASSIAN_BASE_URL`
- `ATLASSIAN_EMAIL`
- `ATLASSIAN_API_TOKEN`
- `BITBUCKET_TOKEN` (optional)

## Workflow
1. Load existing values from `~/.atlassian_env` (if present).
2. Show a menu of config keys and current values/status.
3. Update only selected items; unselected items keep existing values.
4. Persist values via `skills/scripts/setup_atlassian_env.sh`.
5. Return changed fields summary (never print full token values).

## Execution
Run:
```bash
skills/scripts/reset_sl_skill_config.sh
```

## Rules
- Never print full token values in output.
- If required fields have no existing value and user leaves them empty, ask again.
