---
name: reset-sl-skill-config
description: Reset sl-skill Atlassian configuration with agent-guided prompts. Use when user wants to update or reconfigure ATLASSIAN_BASE_URL, ATLASSIAN_EMAIL, ATLASSIAN_API_TOKEN, or BITBUCKET_TOKEN.
---

# Reset SL Skill Config

## Goal
通过 agent 对话引导用户修改 `sl-skills` 配置，不直接先运行交互式 shell 脚本。

## Managed Config
- `ATLASSIAN_BASE_URL`
- `ATLASSIAN_EMAIL`
- `ATLASSIAN_API_TOKEN`
- `BITBUCKET_TOKEN` (optional)

## Workflow
1. Load existing values from `~/.atlassian_env` (if present).
2. Agent先列出可修改项，并让用户选择要改哪些 key：
   - `ATLASSIAN_BASE_URL`
   - `ATLASSIAN_EMAIL`
   - `ATLASSIAN_API_TOKEN`
   - `BITBUCKET_TOKEN`（可选，可清空）
3. Agent逐项向用户询问新值（仅询问被选择项）：
   - 未选择项沿用旧值
   - `ATLASSIAN_API_TOKEN`、`BITBUCKET_TOKEN` 视为敏感信息，不回显明文
4. Agent整理最终配置后，一次性执行持久化：
   - `skills/scripts/setup_atlassian_env.sh "<base_url>" "<email>" "<api_token>" "<bitbucket_token>"`
   - 若要清空 `BITBUCKET_TOKEN`，第4个参数传空字符串 `""`
5. 返回变更摘要（只说 updated/unchanged/cleared，绝不打印完整 token）。

## Execution
默认使用 Agent 引导流程（对话收集 -> 一次性持久化），不要先直接运行：

```bash
skills/scripts/reset_sl_skill_config.sh
```

只有在用户明确要求“运行脚本菜单”时，才执行该脚本。

## Rules
- Never print full token values in output.
- If required fields have no existing value and user leaves them empty, ask again.
