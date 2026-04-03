#!/bin/bash
# start-dev.sh - 一键启动开发环境
# 用法: ./start-dev.sh [项目路径]

PROJECT_PATH=${1:-$(pwd)}
SESSION_NAME=$(basename "$PROJECT_PATH")

# 检查是否已有同名 session
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach -t "$SESSION_NAME"
    exit 0
fi

# 创建新 session
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_PATH"

# 窗格 1: 代码编辑（保持默认）

# 窗格 2: OpenClaw
tmux split-window -h -c "$PROJECT_PATH"
tmux send-keys 'openclaw' C-m

# 窗格 3: 终端/测试
tmux split-window -v -c "$PROJECT_PATH"
tmux resize-pane -t 0 -x 60%

# 选择代码编辑窗格
tmux select-pane -t 0

# 附加到 session
tmux attach -t "$SESSION_NAME"
