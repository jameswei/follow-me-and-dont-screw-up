# 环境准备指南 (Environment Setup Guide)
# 位置: shared/setup/environment-setup.md
# 用途: 指导 Agent 检查和准备开发环境

# =============================================================================
# 核心原则
# =============================================================================

1. **检查优先**: 任何工作开始前，先检查环境
2. **用户确认**: 安装操作必须获得用户明确授权
3. **渐进回退**: 项目级 → 用户级 → 系统级 → 容器化
4. **文档记录**: 所有环境决策记录到 `docs/ENVIRONMENT.md`

# =============================================================================
# 工具检查准备环节
# =============================================================================

## 检查流程

```
┌─────────────────────────────────────────────────────────────┐
│  Step 1: 检测必需工具                                         │
│  命令: which <tool> / command -v <tool>                      │
│  结果: 已安装 / 未安装                                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Step 2: 检查版本兼容性                                       │
│  命令: <tool> --version                                      │
│  结果: 版本满足 / 需要升级                                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Step 3: 验证工具功能                                         │
│  命令: 运行简单测试命令                                       │
│  结果: 正常工作 / 异常                                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Step 4: 报告状态                                             │
│  - 全部就绪: 继续工作                                         │
│  - 部分缺失: 提供安装方案，请求确认                           │
│  - 严重缺失: 暂停工作，等待环境就绪                           │
└─────────────────────────────────────────────────────────────┘
```

## 检查脚本模板

### 通用检查函数

```bash
#!/bin/bash
# check-env.sh - 环境检查脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
        local version=$($tool --version 2>&1 | head -1)
        echo -e "${GREEN}✅${NC} $tool: $version"
        ((CHECKS_PASSED++))
        return 0
    else
        echo -e "${RED}❌${NC} $tool: 未安装"
        echo "   安装命令: $install_cmd"
        ((CHECKS_FAILED++))
        return 1
    fi
}

check_optional() {
    local tool=$1
    local install_cmd=$2
    
    if command -v "$tool" &> /dev/null; then
        echo -e "${GREEN}✅${NC} $tool (可选): 已安装"
    else
        echo -e "${YELLOW}⚠️${NC} $tool (可选): 未安装"
        echo "   安装命令: $install_cmd"
        ((CHECKS_WARNING++))
    fi
}

# 主检查逻辑
echo "🔍 检查开发环境..."
echo ""

# 根据项目类型检查
# 具体检查项在下方按语言定义

echo ""
echo "=============================="
echo "检查结果:"
echo "  通过: $CHECKS_PASSED"
echo "  失败: $CHECKS_FAILED"
echo "  警告: $CHECKS_WARNING"
echo "=============================="

if [ $CHECKS_FAILED -gt 0 ]; then
    echo ""
    echo -e "${RED}❌ 环境检查未通过，请安装缺失的工具${NC}"
    exit 1
fi

if [ $CHECKS_WARNING -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}⚠️ 环境基本就绪，但缺少可选工具${NC}"
fi

echo ""
echo -e "${GREEN}✅ 环境检查完成！${NC}"
```

# =============================================================================
# 语言特定检查
# =============================================================================

## Python (使用 uv)

### 检查项

```bash
check_python_uv() {
    echo "📦 Python 环境检查 (使用 uv)..."
    
    # 必需工具
    check_tool "uv" "" "curl -LsSf https://astral.sh/uv/install.sh | sh"
    check_tool "python3" "3.11" "uv python install 3.11"
    
    # 可选工具
    check_optional "ruff" "uv tool install ruff"
    check_optional "mypy" "uv tool install mypy"
    check_optional "pytest" "uv tool install pytest"
    
    # 检查 uv 版本
    if command -v uv &> /dev/null; then
        echo ""
        echo "uv 信息:"
        uv --version
        uv python list
    fi
}
```

### 环境初始化

```bash
#!/bin/bash
# setup-python-uv.sh

echo "🐍 初始化 Python 环境 (uv)..."

# 1. 检查 uv
if ! command -v uv &> /dev/null; then
    echo "安装 uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.cargo/env
fi

# 2. 安装 Python (如需要)
uv python install 3.11

# 3. 创建虚拟环境
uv venv --python 3.11

# 4. 安装依赖
if [ -f "pyproject.toml" ]; then
    uv pip install -e ".[dev]"
else
    echo "未找到 pyproject.toml，创建默认配置..."
    cat > pyproject.toml << 'EOF'
[project]
name = "my-project"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov",
    "mypy>=1.0",
    "ruff>=0.1.0",
]

[tool.ruff]
line-length = 88

[tool.mypy]
strict = true
EOF
    uv pip install -e ".[dev]"
fi

# 5. 安装工具
uv tool install ruff
uv tool install mypy
uv tool install pytest

echo "✅ Python 环境初始化完成！"
echo ""
echo "使用命令:"
echo "  source .venv/bin/activate  # 激活虚拟环境"
echo "  uv run python              # 运行 Python"
echo "  uv run pytest              # 运行测试"
```

## TypeScript (使用 nvm + npm/bun)

### 检查项

```bash
check_typescript() {
    echo "📦 TypeScript 环境检查..."
    
    # 版本管理器 (二选一)
    if command -v nvm &> /dev/null; then
        echo -e "${GREEN}✅${NC} nvm: 已安装"
        nvm --version
    elif command -v fnm &> /dev/null; then
        echo -e "${GREEN}✅${NC} fnm: 已安装"
        fnm --version
    else
        echo -e "${YELLOW}⚠️${NC} Node 版本管理器: 未安装 (推荐 nvm 或 fnm)"
        echo "   nvm 安装: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
        echo "   fnm 安装: curl -fsSL https://fnm.vercel.app/install | bash"
    fi
    
    # Node.js
    check_tool "node" "18.0.0" "nvm install 20 && nvm use 20"
    check_tool "npm" "9.0.0" "随 Node 安装"
    
    # 可选: bun
    check_optional "bun" "curl -fsSL https://bun.sh/install | bash"
    
    # 包管理器选择
    if command -v bun &> /dev/null; then
        echo -e "${GREEN}✅${NC} 检测到 bun，将使用 bun 作为首选包管理器"
    else
        echo -e "${GREEN}✅${NC} 使用 npm 作为包管理器"
    fi
}
```

### 环境初始化

```bash
#!/bin/bash
# setup-typescript.sh

echo "📘 初始化 TypeScript 环境..."

# 1. 检查/安装 nvm
if ! command -v nvm &> /dev/null; then
    echo "安装 nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# 2. 安装 Node.js
nvm install 20
nvm use 20
nvm alias default 20

# 3. 可选: 安装 bun
if ! command -v bun &> /dev/null; then
    echo "是否安装 bun? (Y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
    fi
fi

# 4. 初始化项目
if [ ! -f "package.json" ]; then
    echo "创建 package.json..."
    
    if command -v bun &> /dev/null; then
        bun init -y
    else
        npm init -y
    fi
    
    # 安装开发依赖
    cat > package.json << 'EOF'
{
  "name": "my-project",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "dev": "tsx watch src/index.ts",
    "test": "vitest",
    "lint": "eslint .",
    "format": "prettier --write ."
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "tsx": "^4.0.0",
    "typescript": "^5.0.0",
    "vitest": "^1.0.0"
  }
}
EOF
fi

# 5. 安装依赖
if command -v bun &> /dev/null; then
    bun install
else
    npm install
fi

# 6. 创建 tsconfig.json
if [ ! -f "tsconfig.json" ]; then
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
fi

echo "✅ TypeScript 环境初始化完成！"
echo ""
echo "使用命令:"
if command -v bun &> /dev/null; then
    echo "  bun dev      # 开发模式"
    echo "  bun test     # 运行测试"
    echo "  bun run lint # 代码检查"
else
    echo "  npm run dev  # 开发模式"
    echo "  npm test     # 运行测试"
    echo "  npm run lint # 代码检查"
fi
```

## Java (使用 jenv + maven)

### 检查项

```bash
check_java() {
    echo "☕ Java 环境检查..."
    
    # 版本管理器
    check_optional "jenv" "brew install jenv"
    
    # JDK
    check_tool "java" "17" "brew install openjdk@17"
    check_tool "javac" "17" "随 JDK 安装"
    
    # 构建工具
    check_tool "mvn" "3.9" "brew install maven"
    check_optional "gradle" "brew install gradle"
    
    # 检查 jenv 配置
    if command -v jenv &> /dev/null; then
        echo ""
        echo "jenv 配置:"
        jenv versions
    fi
}
```

### 环境初始化

```bash
#!/bin/bash
# setup-java.sh

echo "☕ 初始化 Java 环境..."

# 1. 检查/安装 jenv
if ! command -v jenv &> /dev/null; then
    echo "安装 jenv..."
    brew install jenv
    
    # 添加到 shell 配置
    echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(jenv init -)"' >> ~/.zshrc
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi

# 2. 安装 JDK
brew install openjdk@17

# 3. 配置 jenv
jenv add /usr/local/opt/openjdk@17
jenv global 17

# 4. 安装 Maven
brew install maven

# 5. 初始化项目
if [ ! -f "pom.xml" ]; then
    echo "创建 Maven 项目..."
    
    mvn archetype:generate \
        -DgroupId=com.example \
        -DartifactId=my-project \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DarchetypeVersion=1.4 \
        -DinteractiveMode=false
    
    cd my-project
    
    # 更新 pom.xml 添加现代插件
    cat > pom.xml << 'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>my-project</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
            </plugin>
        </plugins>
    </build>
</project>
EOF
fi

echo "✅ Java 环境初始化完成！"
echo ""
echo "使用命令:"
echo "  mvn compile  # 编译"
echo "  mvn test     # 测试"
echo "  mvn package  # 打包"
```

## Go (使用 goenv)

### 检查项

```bash
check_go() {
    echo "🐹 Go 环境检查..."
    
    # 版本管理器
    check_optional "goenv" "brew install goenv"
    
    # Go
    check_tool "go" "1.21" "goenv install 1.21.0 && goenv global 1.21.0"
    
    # 工具
    check_optional "golangci-lint" "brew install golangci-lint"
    
    # 检查 goenv 配置
    if command -v goenv &> /dev/null; then
        echo ""
        echo "goenv 配置:"
        goenv versions
    fi
}
```

### 环境初始化

```bash
#!/bin/bash
# setup-go.sh

echo "🐹 初始化 Go 环境..."

# 1. 检查/安装 goenv
if ! command -v goenv &> /dev/null; then
    echo "安装 goenv..."
    brew install goenv
    
    # 添加到 shell 配置
    echo 'export GOENV_ROOT="$HOME/.goenv"' >> ~/.zshrc
    echo 'export PATH="$GOENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(goenv init -)"' >> ~/.zshrc
    echo 'export PATH="$GOROOT/bin:$PATH"' >> ~/.zshrc
    echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.zshrc
    
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    eval "$(goenv init -)"
fi

# 2. 安装 Go
goenv install 1.21.0
goenv global 1.21.0

# 3. 安装工具
brew install golangci-lint

# 4. 初始化项目
if [ ! -f "go.mod" ]; then
    echo "创建 Go 模块..."
    
    read -p "模块路径 (如 github.com/user/project): " module_path
    go mod init "$module_path"
    
    # 创建目录结构
    mkdir -p cmd/server
    mkdir -p internal
    mkdir -p pkg
    
    # 创建 main.go
    cat > cmd/server/main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
EOF
    
    # 创建 Makefile
    cat > Makefile << 'EOF'
.PHONY: build test lint clean

build:
	go build -o bin/server ./cmd/server

test:
	go test -race -cover ./...

lint:
	golangci-lint run

clean:
	rm -rf bin/
EOF
fi

echo "✅ Go 环境初始化完成！"
echo ""
echo "使用命令:"
echo "  make build  # 编译"
echo "  make test   # 测试"
echo "  make lint   # 代码检查"
```

# =============================================================================
# 创建本地沙盒模板
# =============================================================================

## 沙盒概念

沙盒是一个隔离的、可复现的开发环境，包含：
- 特定版本的运行时
- 项目依赖
- 开发工具
- 预配置的环境变量

## 沙盒类型

### 类型 1: 虚拟环境沙盒 (Python/Node)

```
project/
├── .venv/          # Python 虚拟环境
├── node_modules/   # Node 依赖
├── .env            # 环境变量
└── Makefile        # 统一命令入口
```

### 类型 2: 容器沙盒 (Docker)

创建 `docker-compose.dev.yml`:

```yaml
version: '3.8'

services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/workspace
      - /workspace/node_modules  # 匿名卷，避免覆盖
      - /workspace/.venv
    working_dir: /workspace
    command: sleep infinity  # 保持运行
    environment:
      - NODE_ENV=development
      - PYTHONUNBUFFERED=1
```

创建 `Dockerfile.dev`:

```dockerfile
# 多语言开发环境
FROM ubuntu:22.04

# 安装基础工具
RUN apt-get update && apt-get install -y \
    curl \
    git \
    make \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Python + uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:${PATH}"

# Node.js + nvm
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install 20 && nvm use 20
ENV PATH="${NVM_DIR}/versions/node/v20.0.0/bin:${PATH}"

# Go
RUN curl -Lo go.tar.gz https://go.dev/dl/go1.21.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Java
RUN apt-get update && apt-get install -y openjdk-17-jdk maven

# 工作目录
WORKDIR /workspace

# 默认命令
CMD ["/bin/bash"]
```

使用：

```bash
# 启动开发环境
docker-compose -f docker-compose.dev.yml up -d dev

# 进入容器
docker-compose -f docker-compose.dev.yml exec dev bash

# 在容器内，所有工具已就绪
```

### 类型 3: Dev Container (VS Code)

创建 `.devcontainer/devcontainer.json`:

```json
{
  "name": "Multi-Language Dev",
  "dockerComposeFile": "../docker-compose.dev.yml",
  "service": "dev",
  "workspaceFolder": "/workspace",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-vscode.vscode-typescript-next",
        "golang.Go",
        "vscjava.vscode-java-pack"
      ]
    }
  },
  "postCreateCommand": "make setup"
}
```

# =============================================================================
# 环境检查 Checklist
# =============================================================================

## 项目启动前检查清单

### 通用检查

- [ ] 操作系统类型和版本 (macOS/Linux/Windows)
- [ ] Shell 类型 (bash/zsh/fish)
- [ ] 包管理器可用 (brew/apt/yum)
- [ ] Git 已安装并配置
- [ ] 网络连接正常

### Python 项目

- [ ] `uv` 已安装
- [ ] Python 3.11+ 可用
- [ ] `.venv` 虚拟环境已创建
- [ ] `pyproject.toml` 存在
- [ ] 开发依赖已安装 (`uv pip install -e ".[dev]")`
- [ ] `ruff`, `mypy`, `pytest` 可用

### TypeScript 项目

- [ ] `nvm` 或 `fnm` 已安装
- [ ] Node.js 18+ 已激活
- [ ] `npm` 或 `bun` 可用
- [ ] `node_modules` 已安装
- [ ] `package.json` 存在
- [ ] `tsconfig.json` 配置正确

### Java 项目

- [ ] `jenv` 已安装（可选但推荐）
- [ ] JDK 17+ 已安装
- [ ] `java` 和 `javac` 可用
- [ ] `mvn` 或 `gradle` 已安装
- [ ] `pom.xml` 或 `build.gradle` 存在

### Go 项目

- [ ] `goenv` 已安装（可选但推荐）
- [ ] Go 1.21+ 已安装
- [ ] `go` 命令可用
- [ ] `golangci-lint` 已安装
- [ ] `go.mod` 存在

## 环境文档模板

创建 `docs/ENVIRONMENT.md`:

```markdown
# 环境配置文档

## 项目信息
- 项目名称: [name]
- 创建日期: [date]
- 最后更新: [date]

## 开发环境

### 必需工具
| 工具 | 版本 | 安装方式 | 检查命令 |
|------|------|---------|---------|
| [tool] | [version] | [method] | [command] |

### 可选工具
| 工具 | 版本 | 用途 | 安装方式 |
|------|------|------|---------|
| [tool] | [version] | [purpose] | [method] |

## 快速开始

### 1. 克隆项目
```bash
git clone [repo]
cd [project]
```

### 2. 运行环境检查
```bash
./scripts/check-env.sh
```

### 3. 初始化环境
```bash
./scripts/setup-[language].sh
```

### 4. 验证安装
```bash
make validate
```

## 常见问题

### Q1: [问题]
A: [解决方案]

## 变更记录
- [date]: [变更内容]
```

# =============================================================================
# Agent 使用指南
# =============================================================================

## 会话开始时的标准流程

```
1. 读取项目根目录下的 docs/ENVIRONMENT.md
   ↓ 如不存在
2. 运行 ./scripts/check-env.sh（如存在）
   ↓ 如不存在
3. 执行内置环境检查
   ↓
4. 报告环境状态
   ↓ 环境就绪
5. 开始工作
   ↓ 环境缺失
6. 提供安装方案，请求用户确认
```

## 用户确认模板

```
环境检查结果：

✅ 已安装:
   - uv 0.1.0
   - Python 3.11.4
   - node v20.0.0

❌ 未安装:
   - ruff (Python linter)
   - golangci-lint (Go linter)

建议安装命令：
  uv tool install ruff
  brew install golangci-lint

是否执行安装？(Y/n/abort)
- Y: 执行安装并继续
- n: 跳过，继续工作（部分功能不可用）
- abort: 暂停，等待手动安装
```

## 环境变更记录

任何环境变更必须记录：

```markdown
## 变更记录

### 2026-04-03
- 添加: ruff 0.1.0 (Python linter)
- 升级: Node.js 18 → 20
- 原因: 新项目需要新特性
```
