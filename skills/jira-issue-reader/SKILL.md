---
name: jira-issue-reader
description: Read Jira issue/card details using Jira REST API. Use when user asks to fetch a Jira ticket by key (for example PROJ-123), check status/assignee/priority, inspect description/comments, or summarize issue context for implementation.
---

# Jira Issue Reader

## Inputs
- `issue_key`: Jira key, for example `PROJ-123`
- `fields` (optional): comma-separated Jira fields, default:
  `summary,status,assignee,priority,issuetype,reporter,created,updated,description,comment`

## Required Environment
- `JIRA_BASE_URL` (example: `https://your-domain.atlassian.net`)
- `JIRA_EMAIL`
- `JIRA_API_TOKEN`

## Mandatory Config Bootstrap
1. Check required env vars before reading Jira.
2. If any var is missing, ask user to provide missing values one by one.
3. After user provides values, configure env in current shell session, then continue automatically.
4. Do not ask user to run commands manually unless user explicitly wants manual mode.
5. Never print or repeat full token in response.

Recommended setup command after collecting values:
```bash
export JIRA_BASE_URL='https://your-domain.atlassian.net'
export JIRA_EMAIL='name@company.com'
export JIRA_API_TOKEN='***'
```

Optional persistence (only with explicit user consent):
- write to shell profile (`~/.zshrc`) or project `.env` file.

## Workflow
1. Validate `issue_key` format (`^[A-Z][A-Z0-9]+-[0-9]+$`).
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. Call `skills/scripts/get_jira_issue.sh <issue_key> [fields]`.
4. Return concise summary first, then raw key fields.
5. If request asks for full body, return full JSON payload.

## Output Contract
1. Result: one-paragraph summary.
2. Key Fields: status, assignee, priority, updated time.
3. Next Steps: actionable suggestions for engineering work.

## Failure Handling
- Missing env vars: trigger config bootstrap flow and continue.
- 401/403: ask user to verify token scope and account permissions.
- 404: confirm issue key and project visibility.

## Example
Input:
`/jira-issue-reader: SL-101`

Output:
1. Result: issue summary and current progress.
2. Key Fields: `status=In Progress`, `assignee=Alice`, `priority=High`.
3. Next Steps: implementation or follow-up checklist.
