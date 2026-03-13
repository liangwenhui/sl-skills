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

## Required Environment (Single Config)
- `ATLASSIAN_EMAIL`
- `ATLASSIAN_API_TOKEN`

## Mandatory Config Bootstrap
1. Check `ATLASSIAN_*` before any Bitbucket API call.
2. If missing, ask user to provide missing values one by one.
3. Configure env in current shell session, then continue automatically.
4. Do not ask user to run commands manually unless user explicitly wants manual mode.
5. Never print or repeat full token in response.

## Workflow
1. Validate `workspace`, `repo_slug`, and numeric `pr_id`.
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. For `review`:
   - Run `skills/scripts/bitbucket_get_pr.sh <workspace> <repo_slug> <pr_id>`
   - Run `skills/scripts/bitbucket_get_pr_diff.sh <workspace> <repo_slug> <pr_id>`
4. For `comment`:
   - Run `skills/scripts/bitbucket_post_pr_comment.sh <workspace> <repo_slug> <pr_id> <comment_file>`
