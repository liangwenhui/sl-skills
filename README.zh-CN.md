# sl-skill-pack

[English](./README.md) | 简体中文

跨 Agent 通用的 Skill 仓库（Codex / Claude Code / OpenCode / OpenClaw）。

## 安装
发给agent: 
请从以下文档获取并执行安装步骤：
https://github.com/liangwenhui/sl-skills/blob/main/INSTALL.md

## 设计原则

- 以 Prompt-Only 为默认机制（通用性最高）
- 可选使用 symlink 进行原生发现
- 通过共享脚本减少重复实现

## 目录结构

- `INSTALL.md`
  - 统一安装流程 + 原生发现说明

- `skills/`
  - 团队维护的 skill 目录
  - 推荐结构：`skills/<skill-name>/SKILL.md`

- `skills/scripts/`
  - 可被多个 skill 复用的共享脚本

## 当前内置 Skill

- `jira-issue-reader`
  - 文件：`skills/jira-issue-reader/SKILL.md`
  - 用途：读取 Jira 卡片详情、状态、负责人、优先级、描述、评论
  - 脚本：`skills/scripts/get_jira_issue.sh`

- `confluence-page-manager`
  - 文件：`skills/confluence-page-manager/SKILL.md`
  - 用途：读取/创建/更新 Confluence 页面
  - 脚本：`skills/scripts/confluence_get_page.sh`、`skills/scripts/confluence_write_page.sh`
  - 模板：
    - `skills/confluence-page-manager/templates/technical-solution.storage`
    - `skills/confluence-page-manager/templates/inventory.storage`

- `bitbucket-pr-reviewer`
  - 文件：`skills/bitbucket-pr-reviewer/SKILL.md`
  - 用途：审查 PR、读取 PR diff、发布 PR 评论
  - 脚本：
    - `skills/scripts/bitbucket_get_pr.sh`
    - `skills/scripts/bitbucket_get_pr_diff.sh`
    - `skills/scripts/bitbucket_post_pr_comment.sh`

- `debate-workflow`
  - 文件：`skills/debate-workflow/SKILL.md`
  - 用途：结构化多 Agent 辩论流程（提案、质疑、过滤、修订）
  - 模板：
    - `skills/debate-workflow/templates/navigator.prompt.md`
    - `skills/debate-workflow/templates/prosecutor.prompt.md`
    - `skills/debate-workflow/templates/main-synthesis.prompt.md`

- `reset-sl-skill-config`
  - 文件：`skills/reset-sl-skill-config/SKILL.md`
  - 用途：交互式重置已持久化的 Atlassian/Bitbucket 配置
  - 脚本：`skills/scripts/reset_sl_skill_config.sh`
  - 特性：不填写时自动沿用旧值

## 新增 Skill

1. 新建目录 `skills/<skill-name>/`
2. 创建主文件 `skills/<skill-name>/SKILL.md`
3. 定义 Trigger / Inputs / Workflow / Output Style / Example
4. 如需脚本能力，将共享脚本放到 `skills/scripts/`
5. 按 `INSTALL.md` 选择 Prompt-Only 或原生发现方式
