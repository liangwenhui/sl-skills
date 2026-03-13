# INSTALL

## Step -1: Idempotent Install / Update

使用下面这段命令安装（首次）或更新（再次执行）：

```bash
REPO_URL="https://github.com/liangwenhui/sl-skills.git"
DEST_DIR="${DEST_DIR:-$HOME/.agent-skills/sl-skills}"

mkdir -p "$(dirname "$DEST_DIR")"
if [ -d "$DEST_DIR/.git" ]; then
  git -C "$DEST_DIR" pull --ff-only
else
  git clone "$REPO_URL" "$DEST_DIR"
fi

cd "$DEST_DIR"
```

说明：
- 第一次执行：`git clone`
- 之后重复执行：自动 `git pull --ff-only` 更新 skill

## Step -0.5: Configure Atlassian Account (Prompt on Missing)

安装阶段如果检测到系统环境变量缺失，会提示输入账户信息并持久化到本机。

```bash
# run under repo root
if [ -z "${ATLASSIAN_BASE_URL:-}" ] || [ -z "${ATLASSIAN_EMAIL:-}" ] || [ -z "${ATLASSIAN_API_TOKEN:-}" ]; then
  echo "ATLASSIAN_* is missing. Please input account settings."
  read -r -p "ATLASSIAN_BASE_URL: " ATLASSIAN_BASE_URL
  read -r -p "ATLASSIAN_EMAIL: " ATLASSIAN_EMAIL
  read -r -s -p "ATLASSIAN_API_TOKEN: " ATLASSIAN_API_TOKEN
  echo

  read -r -s -p "BITBUCKET_TOKEN (optional, press Enter to skip): " BITBUCKET_TOKEN
  echo

  ./skills/scripts/setup_atlassian_env.sh "$ATLASSIAN_BASE_URL" "$ATLASSIAN_EMAIL" "$ATLASSIAN_API_TOKEN" "$BITBUCKET_TOKEN"
fi

# load into current shell
[ -f "$HOME/.atlassian_env" ] && source "$HOME/.atlassian_env"
```

## Step -0.4: Grant Agent Permissions (Optional but Recommended)

为了让 agent 能够顺利执行脚本，需要将以下路径添加到 agent 的权限配置中：

```bash
# 需要添加到 permissions.allow 的路径
PERMISSION_PATHS=(
  "$HOME/.atlassian_env"
  "${CODEX_HOME:-$HOME/.codex}/skills"
  "$HOME/.claude/skills"
)

# Claude Code: 添加到 ~/.claude/settings.json
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [ -f "$CLAUDE_SETTINGS" ]; then
  # 读取现有 permissions.allow（若不存在则为空数组）
  EXISTING_ALLOW=$(jq -r '.permissions.allow // [] | join(" ")' "$CLAUDE_SETTINGS" 2>/dev/null || echo "")

  for path in "${PERMISSION_PATHS[@]}"; do
    # 检查是否已存在
    if [[ ! "$EXISTING_ALLOW" == *"$path"* ]]; then
      # 使用 jq 添加到数组
      jq --arg path "$path" '.permissions.allow += [$path]' "$CLAUDE_SETTINGS" > /tmp/settings.json.tmp && mv /tmp/settings.json.tmp "$CLAUDE_SETTINGS"
      echo "Added permission: $path"
    else
      echo "Already in permissions: $path"
    fi
  done
fi

# Codex: 添加到 ${CODEX_HOME:-$HOME/.codex}/config.json
CODEX_CONFIG="${CODEX_HOME:-$HOME/.codex}/config.json"
if [ -f "$CODEX_CONFIG" ]; then
  for path in "${PERMISSION_PATHS[@]}"; do
    if ! jq -e --arg path "$path" '.permissions.allow | if type == "array" then contains([$path]) else false end' "$CODEX_CONFIG" >/dev/null 2>&1; then
      jq --arg path "$path" '.permissions.allow += [$path]' "$CODEX_CONFIG" > /tmp/codex_config.json.tmp && mv /tmp/codex_config.json.tmp "$CODEX_CONFIG"
      echo "Added permission (Codex): $path"
    fi
  done
fi
```

> **注意**：如果 agent 没有写权限，可以跳过此步骤，在需要时手动添加或让用户确认权限。

## Step 0: 先识别当前 Agent

本仓库支持两种方式：
- Prompt-Only（跨 Agent 通用，推荐默认）
- Native Discovery（按当前 Agent 的本地目录挂载）

先让 Agent 回答自己是什么，再决定安装方式。可直接发这句：

```text
请先回答你当前是什么 agent（codex / claude-code / openclaw / opencode / 其他），并给出你本机默认的 skills 配置目录。
```

如果 Agent 无法明确回答，直接走 Option A（Prompt-Only）。

## Option A: Universal Prompt-Only (推荐默认)

1. 打开你的 skill 主文件（例如 `skills/<skill-name>/SKILL.md`）
2. 将内容作为会话起始指令加载
3. 用统一触发语法执行（例如 `/<skill-name>:` 或 `<skill-name>:`）

### Universal Bootstrap Prompt (Template)

```text
Load skill from file: /ABSOLUTE/PATH/TO/skills/<skill-name>/SKILL.md
Treat it as active instructions for this session.
When input starts with "/<skill-name>:" or "<skill-name>:", run the skill workflow.
If there is conflict, prioritize safety and explicit user constraints.
```

## Option B: Native Discovery by Agent (可选)

当 Agent 支持本地 skills 发现时，使用符号链接挂载。

### Codex

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
ln -sfn /ABSOLUTE/PATH/TO/sl-skills/skills/<skill-name> "${CODEX_HOME:-$HOME/.codex}/skills/<skill-name>"
ls -la "${CODEX_HOME:-$HOME/.codex}/skills/<skill-name>"
```

### Claude Code

如果你的环境存在 `~/.claude/skills` 约定目录：

```bash
mkdir -p "$HOME/.claude/skills"
ln -sfn /ABSOLUTE/PATH/TO/sl-skills/skills/<skill-name> "$HOME/.claude/skills/<skill-name>"
ls -la "$HOME/.claude/skills/<skill-name>"
```

若你的 Claude Code 使用其他路径，以实际配置为准。

### OpenClaw

如果你的环境存在 `~/.openclaw/skills` 约定目录：

```bash
mkdir -p "$HOME/.openclaw/skills"
ln -sfn /ABSOLUTE/PATH/TO/sl-skills/skills/<skill-name> "$HOME/.openclaw/skills/<skill-name>"
ls -la "$HOME/.openclaw/skills/<skill-name>"
```

若你的 OpenClaw 使用其他路径，以实际配置为准。

### OpenCode

若有本地 skills 目录，按其配置路径执行同样的 `ln -sfn` 挂载；
若无统一目录规范，使用 Option A（Prompt-Only）。

## Notes

- `ln -sfn` 会覆盖旧链接（不会删除源目录内容）。
- Native Discovery 是“本机级挂载”，Prompt-Only 是“会话级加载”。
- 新开会话通常需要重新加载 Prompt-Only skill。
- 不同 Agent 对 slash 命令支持不同，建议同时支持 `<skill-name>:`。
