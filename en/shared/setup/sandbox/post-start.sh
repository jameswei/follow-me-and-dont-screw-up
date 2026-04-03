#!/bin/bash
# post-start.sh - Dev Container 启动后执行

set -e

echo "🔍 检查环境状态..."

# 显示版本信息
echo ""
echo "环境版本:"
echo "  Python: $(python3 --version 2>/dev/null || echo 'N/A')"
echo "  Node: $(node --version 2>/dev/null || echo 'N/A')"
echo "  Java: $(java --version 2>/dev/null | head -1 || echo 'N/A')"
echo "  Go: $(go version 2>/dev/null || echo 'N/A')"
echo "  Docker: $(docker --version 2>/dev/null || echo 'N/A')"

echo ""
echo "✅ 开发容器已就绪！"
