---
name: jira-issue-reader
description: Read Jira issue/card details using Jira REST API. Use when user asks to fetch a Jira ticket by key (for example PROJ-123), check status/assignee/priority, inspect description/comments, or summarize issue context for implementation.
---

# Jira Issue Reader

## Inputs
- `issue_key`: Jira key, for example `PROJ-123`
- `fields` (optional): comma-separated Jira fields, default:
  `summary,status,assignee,priority,issuetype,reporter,created,updated,description,comment`

## Environment Strategy
Default shared Atlassian env (recommended first-time setup):
- `ATLASSIAN_BASE_URL`
- `ATLASSIAN_EMAIL`
- `ATLASSIAN_API_TOKEN`

Service-specific override (optional):
- `JIRA_BASE_URL`
- `JIRA_EMAIL`
- `JIRA_API_TOKEN`

Resolution order:
- `JIRA_*` first; fallback to `ATLASSIAN_*`.

## Mandatory Config Bootstrap
1. Check effective Jira env before reading Jira.
2. If missing, ask user to provide shared `ATLASSIAN_*` first.
3. Configure env in current shell session, then continue automatically.
4. Do not ask user to run commands manually unless user explicitly wants manual mode.
5. Never print or repeat full token in response.

Recommended first-time setup:
```bash
export ATLASSIAN_BASE_URL='https://your-domain.atlassian.net'
export ATLASSIAN_EMAIL='name@company.com'
export ATLASSIAN_API_TOKEN='***'
```

Optional Jira-only override:
```bash
export JIRA_BASE_URL='https://your-domain.atlassian.net'
export JIRA_EMAIL='name@company.com'
export JIRA_API_TOKEN='***'
```

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
