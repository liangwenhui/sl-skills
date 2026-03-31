---
name: commit-policy
description: Guide commit collaboration under team git commit conventions. Use when the user asks to prepare a commit, split changes into focused commits, generate a compliant commit message, decide AI-NONE vs AI-USE, or amend the latest local commit safely.
---

# Commit Policy

## Goal
Keep each commit small, focused, and compliant with team commit naming rules during AI-assisted development.

## When To Use
- User asks to commit current changes.
- User asks whether the current diff should be split into multiple commits.
- User asks for a commit message that matches team rules.
- User asks whether to use `AI-NONE` or `AI-USE`.
- User asks to amend the latest local commit.

## Required Checks
1. Inspect the current branch, staged changes, and unstaged changes before proposing a commit.
2. Treat unrelated user changes as out of scope. Do not revert them and do not silently include them.
3. Prefer the smallest commit that completes one clear purpose.

## Workflow
1. Assess commit scope.
- If the diff mixes unrelated changes, propose a split plan first.
- If the change is already focused, keep it as one commit.

2. Derive the commit message.
- Format must be `<type>:<subject> <AI-info>`.
- Read [references/commit-format.md](references/commit-format.md) when you need the allowed `type` values, detailed AI flag rules, or examples.
- `subject` must describe the actual change and cannot be empty.

3. Decide `AI-info`.
- Use `AI-USE` when the agent generated, rewrote, or materially edited code, docs, config, or commit text.
- Use `AI-NONE` only when the user explicitly wants to mark the commit as non-AI or the agent did not materially contribute to the change.

4. Present a pre-commit summary to the user.
- Scope of the commit
- Files intended for this commit
- Whether a split is recommended
- Proposed commit message

5. Commit only after user confirmation.
- Do not `push` unless the user explicitly asks.
- Do not use `git commit --amend` unless the user explicitly asks, and only for the latest local commit that has not been pushed.

## Output Contract
When preparing a commit, respond in this order:
1. `Commit Scope`
2. `Split Recommendation`
3. `Proposed Commit Message`
4. `Next Action`

## Guardrails
- Never mix unrelated refactors, generated files, and feature work in one commit unless the user explicitly wants that tradeoff.
- Never auto-stage broad file sets without checking whether they match the intended commit scope.
- If the repository has unexpected dirty files, work around them instead of cleaning them.
- If the commit subject depends on a ticket number, preserve the user's existing ticket style.
