#!/bin/bash
# install.sh - 安装 skill 到 Agent 配置
# Usage: ./install.sh <skill-name> <agent-type>
# Example: ./install.sh code-review codex

set -e

SKILL_NAME=$1
AGENT_TYPE=$2

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 帮助信息
show_help() {
    echo "Usage: ./install.sh <skill-name> <agent-type>"
    echo ""
    echo "Available skills:"
    ls -1 ../ | grep -v "install.sh\|README.md" | sed 's/^/  - /'
    echo ""
    echo "Agent types:"
    echo "  - codex    (OpenAI Codex)"
    echo "  - cursor   (Cursor IDE)"
    echo "  - claude   (Claude Code)"
    echo ""
    echo "Examples:"
    echo "  ./install.sh code-review codex"
    echo "  ./install.sh test-generation cursor"
    echo "  ./install.sh static-analysis claude"
}

# 检查参数
if [ -z "$SKILL_NAME" ] || [ -z "$AGENT_TYPE" ]; then
    show_help
    exit 1
fi

# 检查 skill 是否存在
SKILL_DIR="$(dirname "$0")/$SKILL_NAME"
if [ ! -d "$SKILL_DIR" ]; then
    echo -e "${RED}❌ Skill not found: $SKILL_NAME${NC}"
    echo ""
    echo "Available skills:"
    ls -1 "$(dirname "$0")" | grep -v "install.sh\|README.md" | sed 's/^/  - /'
    exit 1
fi

# 检查 skill 文件
if [ ! -f "$SKILL_DIR/prompt.md" ]; then
    echo -e "${RED}❌ prompt.md not found in $SKILL_NAME${NC}"
    exit 1
fi

echo -e "${BLUE}🔧 Installing skill: $SKILL_NAME → $AGENT_TYPE${NC}"
echo ""

# 根据 Agent 类型安装
case $AGENT_TYPE in
    codex)
        TARGET_FILE="$HOME/.codex/instructions.md"
        if [ ! -f "$TARGET_FILE" ]; then
            echo -e "${YELLOW}⚠️ Codex config not found at $TARGET_FILE${NC}"
            echo "Creating..."
            mkdir -p "$HOME/.codex"
            touch "$TARGET_FILE"
        fi
        
        echo -e "${BLUE}📄 Appending to $TARGET_FILE${NC}"
        echo "" >> "$TARGET_FILE"
        echo "# Skill: $SKILL_NAME" >> "$TARGET_FILE"
        echo "# Installed: $(date)" >> "$TARGET_FILE"
        cat "$SKILL_DIR/prompt.md" >> "$TARGET_FILE"
        echo -e "${GREEN}✅ Installed to Codex${NC}"
        ;;
        
    cursor)
        TARGET_FILE="$HOME/.cursorrules"
        if [ ! -f "$TARGET_FILE" ]; then
            echo -e "${YELLOW}⚠️ Cursor config not found at $TARGET_FILE${NC}"
            echo "Creating..."
            touch "$TARGET_FILE"
        fi
        
        echo -e "${BLUE}📄 Appending to $TARGET_FILE${NC}"
        echo "" >> "$TARGET_FILE"
        echo "# Skill: $SKILL_NAME" >> "$TARGET_FILE"
        echo "# Installed: $(date)" >> "$TARGET_FILE"
        cat "$SKILL_DIR/prompt.md" >> "$TARGET_FILE"
        echo -e "${GREEN}✅ Installed to Cursor${NC}"
        ;;
        
    claude)
        echo -e "${YELLOW}⚠️ Claude Code doesn't have a config file${NC}"
        echo "Please manually add the skill prompt to your Claude Code session"
        echo ""
        echo "Skill prompt location:"
        echo "  $SKILL_DIR/prompt.md"
        echo ""
        echo "You can view it with:"
        echo "  cat $SKILL_DIR/prompt.md"
        ;;
        
    *)
        echo -e "${RED}❌ Unknown agent type: $AGENT_TYPE${NC}"
        echo ""
        echo "Supported agents:"
        echo "  - codex"
        echo "  - cursor"
        echo "  - claude"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ Skill '$SKILL_NAME' installed successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the installed skill in your agent config"
echo "  2. Test the skill with a sample task"
echo "  3. Customize if needed"
