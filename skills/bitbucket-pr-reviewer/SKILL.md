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
- `ATLASSIAN_EMAIL`
- `BITBUCKET_TOKEN` (recommended)

Fallback order for token:
- `BITBUCKET_TOKEN`
- `BITBUCKET_APP_PASSWORD`
- `ATLASSIAN_API_TOKEN`

## Mandatory Config Bootstrap (Persistent)
1. Check effective Bitbucket credentials before API call.
2. If missing, ask user to provide required values.
3. Persist config by running:
   `skills/scripts/setup_atlassian_env.sh <base_url> <email> <api_token> [bitbucket_token]`
4. Continue automatically after persistence.
5. Never print or repeat full token in response.

## Workflow
1. Validate `workspace`, `repo_slug`, and numeric `pr_id`.
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. For `review`:
   - Run `skills/scripts/bitbucket_get_pr.sh <workspace> <repo_slug> <pr_id>`
   - Run `skills/scripts/bitbucket_get_pr_diff.sh <workspace> <repo_slug> <pr_id>`
4. For `comment`:
   - Run `skills/scripts/bitbucket_post_pr_comment.sh <workspace> <repo_slug> <pr_id> <comment_file>`
