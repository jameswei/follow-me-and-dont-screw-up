#!/bin/bash
# check-env.sh - 通用环境检查脚本
# 根据项目类型自动检测所需工具

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查计数器
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

# 检查函数
check_tool() {
    local tool=$1
    local min_version=$2
    local install_cmd=$3
    
    if command -v "$tool" &> /dev/null; then
        local version
        version=$($tool --version 2>&1 | head -1 || echo "unknown")
        echo -e "${GREEN}✅${NC} $tool: $version"
        ((CHECKS_PASSED++))
        return 0
    else
        echo -e "${RED}❌${NC} $tool: 未安装"
        echo "   安装: $install_cmd"
        ((CHECKS_FAILED++))
        return 1
    fi
}

check_optional() {
    local tool=$1
    local install_cmd=$2
    
    if command -v "$tool" &> /dev/null; then
        local version
        version=$($tool --version 2>&1 | head -1 || echo "unknown")
        echo -e "${GREEN}✅${NC} $tool (可选): $version"
    else
        echo -e "${YELLOW}⚠️${NC} $tool (可选): 未安装"
        echo "   安装: $install_cmd"
        ((CHECKS_WARNING++))
    fi
}

# 检测项目类型
detect_project_type() {
    if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        echo "python"
    elif [ -f "package.json" ]; then
        echo "typescript"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        echo "java"
    elif [ -f "go.mod" ]; then
        echo "go"
    else
        echo "unknown"
    fi
}

# Python 项目检查
check_python() {
    echo -e "\n${BLUE}📦 Python 项目检查${NC}"
    echo "=============================="
    
    # 必需
    check_tool "uv" "" "curl -LsSf https://astral.sh/uv/install.sh | sh"
    check_tool "python3" "3.11" "uv python install 3.11"
    
    # 可选
    check_optional "ruff" "uv tool install ruff"
    check_optional "mypy" "uv tool install mypy"
    check_optional "pytest" "uv tool install pytest"
    
    # 虚拟环境
    if [ -d ".venv" ]; then
        echo -e "${GREEN}✅${NC} 虚拟环境: .venv 已创建"
    else
        echo -e "${YELLOW}⚠️${NC} 虚拟环境: 未创建"
        echo "   创建: uv venv --python 3.11"
    fi
}

# TypeScript 项目检查
check_typescript() {
    echo -e "\n${BLUE}📘 TypeScript 项目检查${NC}"
    echo "=============================="
    
    # 版本管理器
    if command -v nvm &> /dev/null; then
        echo -e "${GREEN}✅${NC} nvm: $(nvm --version)"
    elif command -v fnm &> /dev/null; then
        echo -e "${GREEN}✅${NC} fnm: $(fnm --version)"
    else
        echo -e "${YELLOW}⚠️${NC} Node 版本管理器: 未安装"
        echo "   安装 nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
        echo "   或 fnm: curl -fsSL https://fnm.vercel.app/install | bash"
    fi
    
    # 必需
    check_tool "node" "18.0.0" "nvm install 20 && nvm use 20"
    check_tool "npm" "9.0.0" "随 Node 安装"
    
    # 可选
    check_optional "bun" "curl -fsSL https://bun.sh/install | bash"
    
    # 依赖
    if [ -d "node_modules" ]; then
        echo -e "${GREEN}✅${NC} 依赖: node_modules 已安装"
    else
        echo -e "${YELLOW}⚠️${NC} 依赖: node_modules 未安装"
        echo "   安装: npm install 或 bun install"
    fi
}

# Java 项目检查
check_java() {
    echo -e "\n${BLUE}☕ Java 项目检查${NC}"
    echo "=============================="
    
    # 版本管理器
    check_optional "jenv" "brew install jenv"
    
    # 必需
    check_tool "java" "17" "brew install openjdk@17"
    check_tool "javac" "17" "随 JDK 安装"
    check_tool "mvn" "3.9" "brew install maven"
    
    # 可选
    check_optional "gradle" "brew install gradle"
}

# Go 项目检查
check_go() {
    echo -e "\n${BLUE}🐹 Go 项目检查${NC}"
    echo "=============================="
    
    # 版本管理器
    check_optional "goenv" "brew install goenv"
    
    # 必需
    check_tool "go" "1.21" "goenv install 1.21.0 && goenv global 1.21.0"
    
    # 工具
    check_optional "golangci-lint" "brew install golangci-lint"
}

# 通用检查
check_common() {
    echo -e "\n${BLUE}🔧 通用工具检查${NC}"
    echo "=============================="
    
    check_tool "git" "2.0" "随系统安装"
    check_tool "make" "" "xcode-select --install 或 apt-get install make"
    check_optional "docker" "https://docs.docker.com/get-docker/"
    check_optional "docker-compose" "随 Docker 安装"
}

# 主逻辑
main() {
    echo "🔍 开发环境检查"
    echo "=============================="
    echo ""
    
    # 检测项目类型
    PROJECT_TYPE=$(detect_project_type)
    echo -e "检测到项目类型: ${BLUE}$PROJECT_TYPE${NC}"
    echo ""
    
    # 通用检查
    check_common
    
    # 项目特定检查
    case $PROJECT_TYPE in
        python)
            check_python
            ;;
        typescript)
            check_typescript
            ;;
        java)
            check_java
            ;;
        go)
            check_go
            ;;
        unknown)
            echo -e "\n${YELLOW}⚠️ 未检测到项目类型，请检查项目文件${NC}"
            echo "支持的类型: Python (pyproject.toml), TypeScript (package.json), Java (pom.xml), Go (go.mod)"
            ;;
    esac
    
    # 总结
    echo ""
    echo "=============================="
    echo "检查结果:"
    echo -e "  ${GREEN}通过: $CHECKS_PASSED${NC}"
    echo -e "  ${RED}失败: $CHECKS_FAILED${NC}"
    echo -e "  ${YELLOW}警告: $CHECKS_WARNING${NC}"
    echo "=============================="
    
    if [ $CHECKS_FAILED -gt 0 ]; then
        echo ""
        echo -e "${RED}❌ 环境检查未通过${NC}"
        echo "请安装缺失的工具，或运行对应的 setup 脚本:"
        echo "  ./scripts/setup-$PROJECT_TYPE.sh"
        exit 1
    fi
    
    if [ $CHECKS_WARNING -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}⚠️ 环境基本就绪，但缺少可选工具${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}✅ 环境检查完成！${NC}"
}

main "$@"
