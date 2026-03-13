---
name: jira-issue-reader
description: Read Jira issue/card details using Jira REST API. Use when user asks to fetch a Jira ticket by key (for example PROJ-123), check status/assignee/priority, inspect description/comments, or summarize issue context for implementation.
---

# Jira Issue Reader

## Inputs
- `issue_key`: Jira key, for example `PROJ-123`
- `fields` (optional): comma-separated Jira fields, default:
  `summary,status,assignee,priority,issuetype,reporter,created,updated,description,comment`

## Required Environment (Single Config)
- `ATLASSIAN_BASE_URL`
- `ATLASSIAN_EMAIL`
- `ATLASSIAN_API_TOKEN`

## Mandatory Config Bootstrap (Persistent)
1. Check `ATLASSIAN_*` before reading Jira.
2. If missing, ask user to provide missing values one by one.
3. Persist config by running:
   `skills/scripts/setup_atlassian_env.sh <base_url> <email> <api_token>`
4. Continue automatically after persistence.
5. Never print or repeat full token in response.

## Workflow
1. Validate `issue_key` format (`^[A-Z][A-Z0-9]+-[0-9]+$`).
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. Call `skills/scripts/get_jira_issue.sh <issue_key> [fields]`.
4. Return concise summary first, then raw key fields.
5. If request asks for full body, return full JSON payload.
