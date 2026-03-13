---
name: debate-workflow
description: Run a structured multi-agent debate workflow to stress-test a solution before execution. Use when user asks for方案设计、架构决策、技术选型或高风险改动评审，且需要先论证再落地。
---

# Debate Workflow

## Goal
在不偏离用户需求的前提下，让主方案经历“需求对齐检查 + 反驳质疑 + 再对齐检查”，输出可执行的修订方案。

## Roles
- `main_agent`: 方案提出与修订负责人。
- `navigator_agent`: 需求守门员。只拿到用户需求（以及在第 2 轮拿到检察官结论），判断是否偏题。
- `prosecutor_agent`: 质疑者。基于用户需求 + 导航者结论，对主方案找漏洞、提替代方案、提出质疑。

## Mandatory Inputs
- `user_requirement`: 用户原始需求（完整文本）

## Workflow
1. Main Draft
- main_agent 基于 `user_requirement` 产出 `main_plan_v1`。
- 产出格式必须包含：
  - `Assumptions`
  - `Proposed Plan`
  - `Tradeoffs`

2. Navigator Check #1
- navigator_agent 只读取 `user_requirement` 与 `main_plan_v1`。
- 输出 `navigator_report_v1`：
  - `alignment_score` (0-100)
  - `off_requirement_points`（偏离点）
  - `missing_requirement_points`（遗漏点）
  - `must_fix_before_debate`（进入反驳前必须修正项）

3. Prosecutor Challenge
- prosecutor_agent 读取：
  - `user_requirement`
  - `navigator_report_v1`
  - `main_plan_v1`
- 输出 `prosecutor_report`：
  - `critical_risks`（关键风险）
  - `logical_gaps`（逻辑漏洞）
  - `better_alternatives`（更优方案）
  - `challenge_questions`（对 main 的质疑）
  - `change_requests`（建议修改项，按优先级）

4. Navigator Check #2
- navigator_agent 读取：
  - `user_requirement`
  - `prosecutor_report`
- 输出 `navigator_report_v2`：
  - `valid_challenges`（与需求相关的质疑）
  - `out_of_scope_challenges`（偏离需求的质疑）
  - `accepted_change_requests`（建议 main 采纳）

5. Main Revision
- main_agent 依据 `navigator_report_v2` 修订为 `main_plan_v2`。
- 必须输出：
  - `What Changed`
  - `Why Changed`
  - `Rejected Suggestions and Reason`
  - `Final Plan`

## Guardrails
- navigator_agent 不参与方案设计，只做“是否贴合需求”的判定。
- prosecutor_agent 必须提出可操作替代方案，不能只否定不建设。
- 所有 agent 都不得引入与 `user_requirement` 无关的目标。
- 若需求信息不足，先列 `clarification_questions`，再继续流程。

## Output Contract (to user)
1. `Final Plan`
2. `Debate Summary`
3. `Accepted vs Rejected Changes`
4. `Open Questions`

## Suggested Prompt Templates
- Navigator template: `skills/debate-workflow/templates/navigator.prompt.md`
- Prosecutor template: `skills/debate-workflow/templates/prosecutor.prompt.md`
- Main synthesis template: `skills/debate-workflow/templates/main-synthesis.prompt.md`
