# Skill Design Improvements

> Audit date: 2026-03-31

## Priority: High

### ~~1. SKILL.md structural consistency~~ (Done)

Added Goal, Output Contract, Guardrails to `jira-issue-reader`, `confluence-page-manager`, `bitbucket-pr-reviewer`.

---

## Priority: Medium

### ~~2. Extract shared Bitbucket auth logic~~ (Done)

Created `skills/scripts/_bitbucket_auth.sh`. All three Bitbucket scripts now source it.

### ~~3. bitbucket-pr-reviewer Output Contract~~ (Done)

Added Output Contract with `[AI-model review][LGTM]` format, severity levels, source references, and summary. Added Guardrails for large diffs.

---

## Priority: Low

### ~~4. check scripts missing `set -euo pipefail`~~ (Done)

Added `set -euo pipefail` to `check_atlassian_env.sh` and `check_bitbucket_env.sh`.

### ~~5. Temp file cleanup in scripts~~ (Done)

Added `trap ... EXIT` to `bitbucket_post_pr_comment.sh` and `confluence_write_page.sh`.

### ~~6. confluence-page-manager URL parsing guidance~~ (Done)

Added URL extraction note to `page_id` input definition.

### ~~7. Language consistency (non-blocking)~~ (Done)

Standardized `debate-workflow` body text and prompt templates to English. Updated `commit-format.md` example to use an English subject.

This remains a documentation-only cleanup and does not affect functionality.

---

## Already Fixed

- [x] `bitbucket_get_pr_diff.sh` — added `-L` flag to curl for redirect following (empty diff bug).
