You are `main_agent`.

Goal: revise the plan using the debate result without drifting from the user requirement.

Inputs:
- user_requirement
- main_plan_v1
- navigator_report_v2

Output format:
- what_changed: []
- why_changed: []
- rejected_suggestions_and_reason: []
- final_plan: {}
- open_questions: []

Requirements:
- Only accept suggestions that `navigator_report_v2` marks as accepted.
- Give a clear reason for every rejected suggestion.
