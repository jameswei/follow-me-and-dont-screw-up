#!/bin/bash
# install.sh - 一键安装所有开发环境配置
# Usage: ./install.sh [all|tmux|skills|agent]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
    echo "Usage: ./install.sh [command]"
    echo ""
    echo "Commands:"
    echo "  all       Install everything (tmux + skills + agent config)"
    echo "  tmux      Install tmux configuration only"
    echo "  skills    Install executable skills"
    echo "  agent     Install agent config (codex/cursor)"
    echo ""
    echo "Examples:"
    echo "  ./install.sh all              # Full setup"
    echo "  ./install.sh tmux             # Tmux only"
    echo "  ./install.sh agent codex      # Codex config"
    echo "  ./install.sh agent cursor     # Cursor config"
}

install_tmux() {
    echo -e "${BLUE}🔧 Installing Tmux configuration...${NC}"
    
    # 备份现有配置
    if [ -f "$HOME/.tmux.conf" ]; then
        echo -e "${YELLOW}⚠️  Backing up existing .tmux.conf${NC}"
        cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$(date +%Y%m%d)"
    fi
    
    # 复制配置
    cp "$SCRIPT_DIR/shared/tmux/tmux.conf" "$HOME/.tmux.conf"
    mkdir -p "$HOME/.tmux"
    cp "$SCRIPT_DIR/shared/tmux/dev-layout.tmux" "$HOME/.tmux/"
    
    # 安装启动脚本
    if [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
        cp "$SCRIPT_DIR/shared/tmux/start-dev.sh" /usr/local/bin/start-dev
        chmod +x /usr/local/bin/start-dev
        echo -e "${GREEN}✅ start-dev installed to /usr/local/bin/${NC}"
    else
        mkdir -p "$HOME/bin"
        cp "$SCRIPT_DIR/shared/tmux/start-dev.sh" "$HOME/bin/start-dev"
        chmod +x "$HOME/bin/start-dev"
        echo -e "${YELLOW}⚠️  start-dev installed to ~/bin/ (add to PATH)${NC}"
    fi
    
    echo -e "${GREEN}✅ Tmux configuration installed!${NC}"
    echo ""
    echo "Quick start:"
    echo "  start-dev ~/your-project    # Start dev environment"
    echo "  tmux source-file ~/.tmux.conf  # Reload config"
}

install_skills() {
    echo -e "${BLUE}🔧 Installing executable skills...${NC}"
    
    SKILLS_DIR="$SCRIPT_DIR/shared/skills/executable"
    
    if [ ! -d "$SKILLS_DIR" ]; then
        echo -e "${RED}❌ Skills directory not found${NC}"
        return 1
    fi
    
    echo "Available skills:"
    for skill in "$SKILLS_DIR"/*/; do
        if [ -d "$skill" ]; then
            skill_name=$(basename "$skill")
            echo "  - $skill_name"
        fi
    done
    
    echo ""
    echo "To install a skill to your agent:"
    echo "  $SKILLS_DIR/install.sh <skill-name> <agent-type>"
    echo ""
    echo "Example:"
    echo "  $SKILLS_DIR/install.sh code-review codex"
}

install_agent() {
    local agent_type=$1
    
    if [ -z "$agent_type" ]; then
        echo -e "${RED}❌ Please specify agent type: codex or cursor${NC}"
        echo "Usage: ./install.sh agent <codex|cursor>"
        return 1
    fi
    
    case $agent_type in
        codex)
            echo -e "${BLUE}🔧 Installing Codex configuration...${NC}"
            mkdir -p "$HOME/.codex"
            
            if [ -f "$HOME/.codex/instructions.md" ]; then
                echo -e "${YELLOW}⚠️  Backing up existing instructions.md${NC}"
                cp "$HOME/.codex/instructions.md" "$HOME/.codex/instructions.md.backup.$(date +%Y%m%d)"
            fi
            
            cp "$SCRIPT_DIR/codex/instructions.md" "$HOME/.codex/instructions.md"
            echo -e "${GREEN}✅ Codex configuration installed to ~/.codex/instructions.md${NC}"
            ;;
            
        cursor)
            echo -e "${BLUE}🔧 Installing Cursor configuration...${NC}"
            
            if [ -f "$HOME/.cursorrules" ]; then
                echo -e "${YELLOW}⚠️  Backing up existing .cursorrules${NC}"
                cp "$HOME/.cursorrules" "$HOME/.cursorrules.backup.$(date +%Y%m%d)"
            fi
            
            cp "$SCRIPT_DIR/cursor/.cursorrules" "$HOME/.cursorrules"
            echo -e "${GREEN}✅ Cursor configuration installed to ~/.cursorrules${NC}"
            ;;
            
        *)
            echo -e "${RED}❌ Unknown agent type: $agent_type${NC}"
            echo "Supported: codex, cursor"
            return 1
            ;;
    esac
}

install_all() {
    echo -e "${BLUE}🚀 Installing complete development environment...${NC}"
    echo ""
    
    install_tmux
    echo ""
    
    install_agent codex
    echo ""
    
    install_agent cursor
    echo ""
    
    install_skills
    echo ""
    
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Start a new terminal session"
    echo "  2. Run: start-dev ~/your-project"
    echo "  3. Or: tmux new -s myproject"
    echo ""
    echo "Documentation:"
    echo "  - Tmux guide: shared/tmux/README.md"
    echo "  - Skills guide: shared/skills/executable/README.md"
    echo "  - Main README: README.md"
}

# 主逻辑
case "${1:-all}" in
    all)
        install_all
        ;;
    tmux)
        install_tmux
        ;;
    skills)
        install_skills
        ;;
    agent)
        install_agent "$2"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
