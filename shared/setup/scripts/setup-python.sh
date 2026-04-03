#!/bin/bash
# setup-python.sh - Python 环境初始化脚本 (使用 uv)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🐍 Python 环境初始化 (使用 uv)${NC}"
echo "=============================="

# 1. 检查/安装 uv
if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}⚠️ uv 未安装，正在安装...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # 尝试加载 uv
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    
    # 检查是否安装成功
    if ! command -v uv &> /dev/null; then
        echo -e "${RED}❌ uv 安装失败${NC}"
        echo "请手动安装: curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi
    
    echo -e "${GREEN}✅ uv 安装成功${NC}"
else
    echo -e "${GREEN}✅ uv 已安装: $(uv --version)${NC}"
fi

# 2. 安装 Python (如需要)
PYTHON_VERSION="${PYTHON_VERSION:-3.11}"
if ! uv python list | grep -q "python-$PYTHON_VERSION"; then
    echo -e "${BLUE}📥 安装 Python $PYTHON_VERSION...${NC}"
    uv python install "$PYTHON_VERSION"
fi
echo -e "${GREEN}✅ Python $PYTHON_VERSION 就绪${NC}"

# 3. 创建虚拟环境
if [ ! -d ".venv" ]; then
    echo -e "${BLUE}📦 创建虚拟环境...${NC}"
    uv venv --python "$PYTHON_VERSION"
    echo -e "${GREEN}✅ 虚拟环境已创建${NC}"
else
    echo -e "${GREEN}✅ 虚拟环境已存在${NC}"
fi

# 4. 安装/更新依赖
if [ -f "pyproject.toml" ]; then
    echo -e "${BLUE}📦 安装项目依赖...${NC}"
    uv pip install -e ".[dev]"
    echo -e "${GREEN}✅ 依赖已安装${NC}"
else
    echo -e "${YELLOW}⚠️ 未找到 pyproject.toml${NC}"
    read -p "是否创建默认配置? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        cat > pyproject.toml << EOF
[project]
name = "my-project"
version = "0.1.0"
description = "My Python project"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov",
    "mypy>=1.0",
    "ruff>=0.1.0",
    "black>=23.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
line-length = 88
target-version = "py311"
select = ["E", "F", "I", "N", "W", "UP", "B", "C4"]

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = "-v --tb=short --cov=src --cov-report=term-missing"
EOF
        
        # 创建目录结构
        mkdir -p src/my_project
        mkdir -p tests
        
        # 创建 __init__.py
        touch src/my_project/__init__.py
        touch src/my_project/py.typed
        
        echo -e "${GREEN}✅ 已创建默认 pyproject.toml${NC}"
        uv pip install -e ".[dev]"
    fi
fi

# 5. 安装开发工具
echo -e "${BLUE}🔧 安装开发工具...${NC}"
uv tool install ruff 2>/dev/null || echo "ruff 已安装"
uv tool install mypy 2>/dev/null || echo "mypy 已安装"
uv tool install pytest 2>/dev/null || echo "pytest 已安装"

# 6. 验证安装
echo ""
echo -e "${BLUE}🔍 验证安装...${NC}"
uv run python --version
uv run ruff --version
uv run mypy --version
uv run pytest --version

echo ""
echo "=============================="
echo -e "${GREEN}✅ Python 环境初始化完成！${NC}"
echo "=============================="
echo ""
echo "使用命令:"
echo "  source .venv/bin/activate  # 激活虚拟环境"
echo "  uv run python              # 运行 Python"
echo "  uv run pytest              # 运行测试"
echo "  uv run ruff check .        # 代码检查"
echo "  uv run ruff format .       # 代码格式化"
echo "  make validate              # 完整验证"
