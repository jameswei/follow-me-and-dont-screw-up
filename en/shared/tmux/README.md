# Tmux 配置指南

## 快速开始

### 1. 安装配置

```bash
# 复制配置文件
cp tmux.conf ~/.tmux.conf

# 复制布局脚本
mkdir -p ~/.tmux
cp dev-layout.tmux ~/.tmux/

# 复制启动脚本
chmod +x start-dev.sh
sudo mv start-dev.sh /usr/local/bin/start-dev

# 重载配置
tmux source-file ~/.tmux.conf
```

### 2. 基本使用

```bash
# 启动新 session
tmux new -s myproject

# 或一键启动开发环境
start-dev ~/my-project
```

### 3. 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+a` | 前缀键（按住后按其他键） |
| `Ctrl+a \|` | 垂直分屏 |
| `Ctrl+a -` | 水平分屏 |
| `Ctrl+a h/j/k/l` | 切换窗格（vim风格） |
| `Ctrl+a H/J/K/L` | 调整窗格大小 |
| `Ctrl+a C-s` | 同步输入（多窗格同时操作） |
| `Ctrl+a O` | 快速启动 OpenClaw |
| `Ctrl+a D` | 创建开发布局 |
| `Ctrl+a T` | 创建三窗格布局 |
| `Ctrl+a r` | 重载配置 |
| `Ctrl+a ?` | 显示帮助 |

### 4. 开发布局

```
┌─────────────────┬─────────────────┐
│                 │   OpenClaw      │
│    代码编辑      │   Agent 对话    │
│    (60%)        │                 │
│                 ├─────────────────┤
│                 │   终端/测试     │
│                 │   npm test      │
└─────────────────┴─────────────────┘
```

## Session 管理

```bash
# 列出所有 session
tmux ls

# 附加到 session
tmux attach -t myproject

# 后台运行（detach）
Ctrl+a d

# 关闭 session
tmux kill-session -t myproject

# 切换 session
Ctrl+a s
```

## 与 OpenClaw 配合

### 场景 1: 边写代码边问 Agent
```bash
start-dev ~/my-project
# 左侧 vim 写代码，右侧 OpenClaw 对话
```

### 场景 2: 长任务后台运行
```bash
tmux new -d -s long-task 'openclaw'
# 做其他事情...
tmux attach -t long-task
```

### 场景 3: 多项目同时工作
```bash
start-dev ~/project-a
tmux detach

start-dev ~/project-b
tmux detach

# 快速切换
tmux attach -t project-a
tmux attach -t project-b
```

## 高级技巧

### 同步输入
在多个窗格同时执行相同命令：
```
Ctrl+a C-s  # 开启同步
# 输入命令...
Ctrl+a C-s  # 关闭同步
```

### 复制模式
```
Ctrl+a [      # 进入复制模式
v             # 开始选择
y             # 复制
Ctrl+a ]      # 粘贴
```

### 保存和恢复会话（需要插件）
```
# 安装 tpm 和 resurrect 插件后
Ctrl+a Ctrl+s  # 保存
Ctrl+a Ctrl+r  # 恢复
```

## 故障排除

### 配置不生效
```bash
tmux source-file ~/.tmux.conf
```

### 快捷键冲突
检查是否有其他程序占用了 `Ctrl+a`：
```bash
# 改为 Ctrl+b（默认）
set -g prefix C-b
```

### 颜色显示异常
```bash
# 检查终端支持
echo $TERM
# 应该显示 screen-256color 或 xterm-256color
```

## 参考

- [Tmux 快捷键速查表](https://tmuxcheatsheet.com/)
- [Tmux 插件列表](https://github.com/tmux-plugins/list)
