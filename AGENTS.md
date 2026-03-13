# Repository Guidelines

## Project Structure & Module Organization
- Root docs: `README.md`, `README.zh-CN.md`, and `INSTALL.md` describe onboarding and installation flows.
- Skills live under `skills/<skill-name>/SKILL.md` (for example, `skills/jira-issue-reader/SKILL.md`).
- Shared automation lives in `skills/scripts/` (Bitbucket, Jira, Confluence, and environment setup scripts).
- Reusable templates live inside skill folders (for example, `skills/confluence-page-manager/templates/` and `skills/debate-workflow/templates/`).

## Build, Test, and Development Commands
- `git -C <repo> pull --ff-only`: update local repo without merge commits.
- `./skills/scripts/setup_atlassian_env.sh <base_url> <email> <api_token> [bitbucket_token]`: persist required credentials to `~/.atlassian_env`.
- `[ -f "$HOME/.atlassian_env" ] && source "$HOME/.atlassian_env"`: load persisted credentials into current shell.
- `./skills/scripts/get_jira_issue.sh SL-123`: verify Jira integration.
- `./skills/scripts/bitbucket_get_pr.sh <workspace> <repo_slug> <pr_id>`: verify Bitbucket integration.
- `./skills/scripts/confluence_get_page.sh <page_id>`: verify Confluence integration.

## Coding Style & Naming Conventions
- Shell scripts use Bash with strict mode: `#!/usr/bin/env bash` and `set -euo pipefail`.
- Prefer small, composable scripts in `skills/scripts/` and keep skill-specific logic in each `SKILL.md`.
- Skill directory names use kebab-case (for example, `reset-sl-skill-config`).
- Script filenames use snake_case (for example, `setup_atlassian_env.sh`).
- Keep docs concise and task-oriented; update both English and Chinese README files when user-facing behavior changes.

## Testing Guidelines
- No dedicated automated test suite is currently defined.
- For changes, run the relevant script directly and verify output with valid inputs plus one invalid-input case.
- If available in your environment, run `shellcheck skills/scripts/*.sh` before opening a PR.

## Commit & Pull Request Guidelines
- Follow Conventional Commit style used in history: `feat: ...`, `docs: ...`, `refactor: ...`.
- Keep commits focused by skill or script area; avoid mixing unrelated refactors and docs edits.
- PRs should include: purpose, changed paths (for example, `skills/bitbucket-pr-reviewer/`), validation commands run, and redacted sample output.
- Link related Jira/Bitbucket items when applicable, and never include raw tokens or secrets in logs/screenshots.

## Security & Configuration Tips
- Credentials must be sourced from environment variables or `~/.atlassian_env`; never hardcode secrets.
- Treat `BITBUCKET_TOKEN`/`ATLASSIAN_API_TOKEN` as sensitive and redact them in all shared artifacts.
