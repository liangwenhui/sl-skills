# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

sl-skills is a cross-agent skill repository for Codex, Claude Code, OpenCode, and OpenClaw. It provides reusable skills for Atlassian integrations (Jira, Confluence, Bitbucket) and AI-assisted development workflows.

## Architecture

Each skill is a self-contained directory under `skills/<skill-name>/` with a `SKILL.md` that defines the skill contract. The `SKILL.md` uses YAML frontmatter (`name`, `description`) followed by sections: Goal, Inputs, Workflow, Output Contract, and Rules/Guardrails.

Skills can optionally include:
- `templates/` — reusable prompt or markup templates
- `references/` — supporting docs (e.g., commit format rules)

Shared shell scripts live in `skills/scripts/` and are called by multiple skills. All scripts source credentials from `~/.atlassian_env` at runtime.

Two installation modes exist (see `INSTALL.md`):
- **Prompt-Only** — portable, session-level loading via any agent
- **Native Discovery** — symlink into agent-specific skill directories (e.g., `~/.codex/skills/`, `~/.claude/skills/`)

## Common Commands

```bash
# Lint all scripts before PR
shellcheck skills/scripts/*.sh

# Verify Atlassian env is configured
./skills/scripts/check_atlassian_env.sh
./skills/scripts/check_bitbucket_env.sh

# Test integrations (requires `source ~/.atlassian_env` first)
./skills/scripts/get_jira_issue.sh SL-123
./skills/scripts/bitbucket_get_pr.sh <workspace> <repo_slug> <pr_id>
./skills/scripts/confluence_get_page.sh <page_id>

# Setup / reset credentials
./skills/scripts/setup_atlassian_env.sh <base_url> <email> <api_token> [bitbucket_token]
./skills/scripts/reset_sl_skill_config.sh
```

## Skills

| Skill | Purpose |
|-------|---------|
| jira-issue-reader | Read Jira issues, status, assignee, priority |
| confluence-page-manager | Read/create/update Confluence pages via REST API |
| bitbucket-pr-reviewer | Review PRs, fetch diffs, post inline/general comments |
| debate-workflow | Multi-agent structured debate for plan validation |
| commit-policy | Prepare focused commits under team naming rules with AI-USE/AI-NONE flags |
| reset-sl-skill-config | Reset Atlassian/Bitbucket config interactively |

## Adding a New Skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)
2. Define Goal → Inputs → Workflow → Output Contract → Rules
3. Put reusable scripts in `skills/scripts/` (snake_case filenames)
4. Update both `README.md` and `README.zh-CN.md`

## Conventions

- Skill directory names: **kebab-case**; script filenames: **snake_case**
- Shell scripts: `#!/usr/bin/env bash` with `set -euo pipefail`
- Commits: Conventional Commits (`feat:`, `docs:`, `refactor:`, etc.)
- Dual-language docs: any behavior change must update both English and Chinese READMEs
- Credentials live in `~/.atlassian_env` — never hardcode secrets
