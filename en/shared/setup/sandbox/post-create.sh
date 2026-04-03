#!/bin/bash
# post-create.sh - Dev Container 创建后执行

set -e

echo "🚀 初始化开发环境..."

# 检测项目类型并初始化
if [ -f "pyproject.toml" ]; then
    echo "📦 检测到 Python 项目"
    if [ ! -d ".venv" ]; then
        uv venv --python 3.11
        uv pip install -e ".[dev]"
    fi
elif [ -f "package.json" ]; then
    echo "📦 检测到 TypeScript 项目"
    if [ ! -d "node_modules" ]; then
        npm install
    fi
elif [ -f "pom.xml" ]; then
    echo "📦 检测到 Java 项目"
    mvn dependency:go-offline
elif [ -f "go.mod" ]; then
    echo "📦 检测到 Go 项目"
    go mod download
fi

# 安装 git hooks
if [ -d ".git" ]; then
    echo "🔧 配置 git hooks..."
    # 可以在这里配置 pre-commit hooks
fi

echo "✅ 开发环境初始化完成！"
