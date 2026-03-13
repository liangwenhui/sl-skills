# sl-skill-pack

跨 Agent 通用的 Skill 仓库（Codex / Claude Code / OpenCode / OpenClaw）。

## Installation

Fetch and follow instructions from https://github.com/liangwenhui/sl-skills/blob/main/INSTALL.md

## 设计原则

- 以 Prompt-Only 为默认机制（最通用）
- 可选支持 Codex 原生发现（symlink）
- 支持共享脚本能力，减少重复实现

## 目录结构

- `INSTALL.md`
  - 通用加载方法 + Codex 原生发现挂载方法

- `skills/`
  - 团队的 skill 目录
  - 每个 skill 建议使用：`skills/<skill-name>/SKILL.md`

- `skills/scripts/`
  - skill 共享脚本目录（可被多个 skill 复用）

## 当前示例 Skill

- `jira-issue-reader`
  - 文件：`skills/jira-issue-reader/SKILL.md`
  - 用途：读取 Jira 卡片详情、状态、负责人、优先级、描述和评论
  - 依赖脚本：`skills/scripts/get_jira_issue.sh`
  - 特性：若缺少 Jira 环境变量，agent 先询问并在会话内完成配置，再继续读取

- `confluence-page-manager`
  - 文件：`skills/confluence-page-manager/SKILL.md`
  - 用途：读取 Confluence 页面；创建/更新页面
  - 依赖脚本：`skills/scripts/confluence_get_page.sh`、`skills/scripts/confluence_write_page.sh`
  - 内置模板：
    - `skills/confluence-page-manager/templates/technical-solution.storage`
    - `skills/confluence-page-manager/templates/inventory.storage`
  - 特性：若缺少 Confluence 环境变量，agent 先询问并在会话内完成配置，再继续执行

- `bitbucket-pr-reviewer`
  - 文件：`skills/bitbucket-pr-reviewer/SKILL.md`
  - 用途：审查 Bitbucket PR、读取 PR diff、发布 PR 评论
  - 依赖脚本：
    - `skills/scripts/bitbucket_get_pr.sh`
    - `skills/scripts/bitbucket_get_pr_diff.sh`
    - `skills/scripts/bitbucket_post_pr_comment.sh`
  - 特性：若缺少 Bitbucket 环境变量，agent 先询问并在会话内完成配置，再继续执行

- `debate-workflow`
  - 文件：`skills/debate-workflow/SKILL.md`
  - 用途：main 提案 -> navigator 对齐检查 -> prosecutor 反驳质疑 -> navigator 二次过滤 -> main 修订
  - 模板：
    - `skills/debate-workflow/templates/navigator.prompt.md`
    - `skills/debate-workflow/templates/prosecutor.prompt.md`
    - `skills/debate-workflow/templates/main-synthesis.prompt.md`

## 创建新 Skill

1. 新建目录：`skills/<skill-name>/`
2. 创建主文件：`skills/<skill-name>/SKILL.md`
3. 在主文件定义：Trigger / Inputs / Workflow / Output Style / Example
4. 如需可执行能力，在 `skills/scripts/` 放共享脚本
5. 按 `INSTALL.md` 选择使用方式（Prompt-Only 或 Codex symlink）
