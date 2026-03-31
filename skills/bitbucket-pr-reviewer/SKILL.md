---
name: bitbucket-pr-reviewer
description: Review Bitbucket pull requests and post PR comments via Bitbucket API. Use when user asks to inspect PR changes, perform code review, identify risks/regressions, or comment on a PR.
---

# Bitbucket PR Reviewer

## Goal
Review Bitbucket pull requests by fetching PR metadata and diff, then produce a structured code review with actionable findings.

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
1. First run check script: `skills/scripts/check_bitbucket_env.sh`
2. If check fails (non-zero exit), proceed with bootstrap:
   - Ask user to provide required values (ATLASSIAN_EMAIL + BITBUCKET_TOKEN).
   - Persist config by running:
     `skills/scripts/setup_atlassian_env.sh <base_url> <email> <api_token> [bitbucket_token]`
3. Continue automatically after persistence.
4. Never print or repeat full token in response.

## Workflow
1. Validate `workspace`, `repo_slug`, and numeric `pr_id`.
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. For `review`:
   - Run `skills/scripts/bitbucket_get_pr.sh <workspace> <repo_slug> <pr_id>`
   - Run `skills/scripts/bitbucket_get_pr_diff.sh <workspace> <repo_slug> <pr_id>`
4. For `comment`:
   - Run `skills/scripts/bitbucket_post_pr_comment.sh <workspace> <repo_slug> <pr_id> <comment_file>`

## Output Contract
When completing a review, respond in this format:

```
[<AI-model> review][✅/❌ LGTM]
- high: <issue description>
  `path/to/file.rb:42` `some_method(arg)`
- medium: <issue description>
  `path/to/file.rb:87` `if condition && other`
- low: <issue description>
  `path/to/file.rb:120` `# TODO: ...`

Summary: <brief overall assessment>
```

Rules:
- Each issue must include source reference: `path:line_number` and a one-line code snippet.
- Group issues by severity level: high > medium > low.
- End with a brief summary of the overall PR quality and key risks.

## Guardrails
- Never expose raw API tokens in output.
- If diff is excessively large, focus review on high-risk files (business logic, security, data migration) and note skipped files.
- Do not approve or merge PRs; this skill only reviews and comments.
- When posting comments, confirm content with the user before executing.
