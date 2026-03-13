---
name: bitbucket-pr-reviewer
description: Review Bitbucket pull requests and post PR comments via Bitbucket API. Use when user asks to inspect PR changes, perform code review, identify risks/regressions, or comment on a PR.
---

# Bitbucket PR Reviewer

## Inputs
- `workspace`: Bitbucket workspace id
- `repo_slug`: repository slug
- `pr_id`: pull request id (number)
- `action`: `review` | `comment`
- `comment` (required for `comment` action)

## Required Environment
- `BITBUCKET_USERNAME`
- `BITBUCKET_APP_PASSWORD`
- `BITBUCKET_API_BASE_URL` (optional, default: `https://api.bitbucket.org/2.0`)

## Mandatory Config Bootstrap
1. Check required env vars before any Bitbucket API call.
2. If any var is missing, ask user to provide missing values one by one.
3. After user provides values, configure env in current shell session, then continue automatically.
4. Do not ask user to run commands manually unless user explicitly wants manual mode.
5. Never print or repeat full app password in response.

Recommended setup command after collecting values:
```bash
export BITBUCKET_USERNAME='name@company.com'
export BITBUCKET_APP_PASSWORD='***'
export BITBUCKET_API_BASE_URL='https://api.bitbucket.org/2.0'
```

## Workflow
1. Validate `workspace`, `repo_slug`, and numeric `pr_id`.
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. For `review`:
   - Run `skills/scripts/bitbucket_get_pr.sh <workspace> <repo_slug> <pr_id>`
   - Run `skills/scripts/bitbucket_get_pr_diff.sh <workspace> <repo_slug> <pr_id>`
   - Produce findings-first review output (bugs, risks, regressions, missing tests), then summary.
4. For `comment`:
   - Draft concise, actionable comment.
   - Run `skills/scripts/bitbucket_post_pr_comment.sh <workspace> <repo_slug> <pr_id> <comment_file>`
5. Confirm action result with PR link/id.

## Review Output Contract
1. Findings (ordered by severity).
2. Open questions / assumptions.
3. Change summary (brief).

## Failure Handling
- Missing env vars: trigger config bootstrap flow and continue.
- 401/403: verify app password scope and repo permissions.
- 404: verify workspace/repo/pr id visibility.
- Empty diff: confirm PR state and source branch.

## Comment Guidance
- Keep comments specific and actionable.
- Reference file and line when possible.
- Prefer one issue per comment.

## Example
Input:
`/bitbucket-pr-reviewer: review workspace=acme repo_slug=payment-service pr_id=42`

Input:
`/bitbucket-pr-reviewer: comment workspace=acme repo_slug=payment-service pr_id=42 comment="Please add a null check before dereference."`
