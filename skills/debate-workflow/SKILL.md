---
name: debate-workflow
description: Run a structured multi-agent debate workflow to stress-test a solution before execution. Use when user asks for solution design, architecture decisions, tech selection, or high-risk change review that requires debate before implementation.
---

# Debate Workflow

## Goal
Stress-test a proposed solution without drifting from the user's request by running "alignment check + adversarial challenge + alignment re-check" and producing an executable revised plan.

## Roles
- `main_agent`: owns the initial proposal and final revision.
- `navigator_agent`: requirement gatekeeper. It only sees the user requirement, and in round 2 the prosecutor conclusions, to judge whether the plan stays on scope.
- `prosecutor_agent`: challenger. It uses the user requirement plus navigator conclusions to find weaknesses, propose alternatives, and raise objections.

## Mandatory Inputs
- `user_requirement`: the user's original request in full

## Workflow
1. Main Draft
- `main_agent` produces `main_plan_v1` from `user_requirement`.
- The output must include:
  - `Assumptions`
  - `Proposed Plan`
  - `Tradeoffs`

2. Navigator Check #1
- `navigator_agent` only reads `user_requirement` and `main_plan_v1`.
- Output `navigator_report_v1`:
  - `alignment_score` (0-100)
  - `off_requirement_points`
  - `missing_requirement_points`
  - `must_fix_before_next_step`
  - `rationale`

3. Prosecutor Challenge
- `prosecutor_agent` reads:
  - `user_requirement`
  - `navigator_report_v1`
  - `main_plan_v1`
- Output `prosecutor_report`:
  - `critical_risks`
  - `logical_gaps`
  - `better_alternatives`
  - `challenge_questions`
  - `change_requests` ranked by priority

4. Navigator Check #2
- `navigator_agent` reads:
  - `user_requirement`
  - `prosecutor_report`
- Output `navigator_report_v2`:
  - `valid_challenges`
  - `out_of_scope_challenges`
  - `accepted_change_requests`

5. Main Revision
- `main_agent` revises the plan into `main_plan_v2` based on `navigator_report_v2`.
- It must output:
  - `what_changed`
  - `why_changed`
  - `rejected_suggestions_and_reason`
  - `final_plan`
  - `open_questions`

## Guardrails
- `navigator_agent` does not design the solution. It only evaluates whether the content matches the requirement.
- `prosecutor_agent` must provide actionable alternatives instead of only criticizing.
- No agent may introduce goals unrelated to `user_requirement`.
- If the requirement is underspecified, list `clarification_questions` first and then continue the workflow.

## Output Contract (to user)
1. `Final Plan`
2. `Debate Summary`
3. `Accepted vs Rejected Changes`
4. `Open Questions`

## Suggested Prompt Templates
- Navigator template: `skills/debate-workflow/templates/navigator.prompt.md`
- Prosecutor template: `skills/debate-workflow/templates/prosecutor.prompt.md`
- Main synthesis template: `skills/debate-workflow/templates/main-synthesis.prompt.md`
