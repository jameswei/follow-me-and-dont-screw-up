# Tmux 开发布局脚本
# 位置: ~/.tmux/dev-layout.tmux
# 用途: 一键创建代码 + Agent + 终端的三窗格布局

# 创建垂直分屏（左代码，右Agent）
split-window -h -c "#{pane_current_path}"

# 在右侧再分屏（上Agent，下终端）
split-window -v -c "#{pane_current_path}"

# 调整大小（左侧占 60%）
resize-pane -t 0 -x 60%

# 选择左侧窗格（代码编辑）
select-pane -t 0

# 显示提示
display-message "Dev layout created! Left: Code, Top-Right: Agent, Bottom-Right: Terminal"
