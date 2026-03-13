# sl-skill-pack

English | [简体中文](./README.zh-CN.md)

A cross-agent skill repository for Codex, Claude Code, OpenCode, and OpenClaw.

## Installation

Fetch and follow instructions from:
https://github.com/liangwenhui/sl-skills/blob/main/INSTALL.md

## Design Principles

- Prompt-Only as the default (most portable)
- Optional native discovery via symlink
- Reusable shared scripts to avoid duplicated logic

## Structure

- `INSTALL.md`
  - Unified setup flow + native discovery guidance

- `skills/`
  - Team-managed skills
  - Recommended layout: `skills/<skill-name>/SKILL.md`

- `skills/scripts/`
  - Shared scripts reusable by multiple skills

## Included Skills

- `jira-issue-reader`
  - File: `skills/jira-issue-reader/SKILL.md`
  - Purpose: read Jira issue details, status, assignee, priority, description, comments
  - Script: `skills/scripts/get_jira_issue.sh`

- `confluence-page-manager`
  - File: `skills/confluence-page-manager/SKILL.md`
  - Purpose: read/create/update Confluence pages
  - Scripts: `skills/scripts/confluence_get_page.sh`, `skills/scripts/confluence_write_page.sh`
  - Templates:
    - `skills/confluence-page-manager/templates/technical-solution.storage`
    - `skills/confluence-page-manager/templates/inventory.storage`

- `bitbucket-pr-reviewer`
  - File: `skills/bitbucket-pr-reviewer/SKILL.md`
  - Purpose: review PRs, fetch PR diff, post PR comments
  - Scripts:
    - `skills/scripts/bitbucket_get_pr.sh`
    - `skills/scripts/bitbucket_get_pr_diff.sh`
    - `skills/scripts/bitbucket_post_pr_comment.sh`

- `debate-workflow`
  - File: `skills/debate-workflow/SKILL.md`
  - Purpose: structured multi-agent debate for plan validation and revision
  - Templates:
    - `skills/debate-workflow/templates/navigator.prompt.md`
    - `skills/debate-workflow/templates/prosecutor.prompt.md`
    - `skills/debate-workflow/templates/main-synthesis.prompt.md`

- `reset-sl-skill-config`
  - File: `skills/reset-sl-skill-config/SKILL.md`
  - Purpose: reset persisted Atlassian/Bitbucket config interactively
  - Script: `skills/scripts/reset_sl_skill_config.sh`
  - Behavior: empty input keeps existing values

## Add a New Skill

1. Create `skills/<skill-name>/`
2. Add `skills/<skill-name>/SKILL.md`
3. Define Trigger / Inputs / Workflow / Output Style / Example
4. Put reusable scripts in `skills/scripts/` when needed
5. Follow `INSTALL.md` for Prompt-Only or native discovery setup
