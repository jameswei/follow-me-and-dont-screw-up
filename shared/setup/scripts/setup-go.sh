#!/bin/bash
# setup-go.sh - Go 环境初始化脚本 (使用 goenv)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🐹 Go 环境初始化 (使用 goenv)${NC}"
echo "=============================="

# 检测包管理器
if command -v brew &> /dev/null; then
    PKG_MGR="brew"
    INSTALL_CMD="brew install"
elif command -v apt-get &> /dev/null; then
    PKG_MGR="apt"
    INSTALL_CMD="sudo apt-get install -y"
else
    echo -e "${YELLOW}⚠️ 未检测到支持的包管理器 (brew/apt)${NC}"
    echo "请手动安装所需工具"
    exit 1
fi

# 1. 检查/安装 goenv
if ! command -v goenv &> /dev/null; then
    echo -e "${YELLOW}⚠️ goenv 未安装，正在安装...${NC}"
    $INSTALL_CMD goenv
    
    # 配置 goenv
    echo 'export GOENV_ROOT="$HOME/.goenv"' >> ~/.zshrc
    echo 'export PATH="$GOENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(goenv init -)"' >> ~/.zshrc
    echo 'export PATH="$GOROOT/bin:$PATH"' >> ~/.zshrc
    echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.zshrc
    
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    eval "$(goenv init -)"
    
    echo -e "${GREEN}✅ goenv 安装成功${NC}"
else
    echo -e "${GREEN}✅ goenv 已安装${NC}"
fi

# 确保 goenv 已加载
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)" 2>/dev/null || true

# 2. 安装 Go
GO_VERSION="${GO_VERSION:-1.21.0}"
echo -e "${BLUE}📥 安装 Go $GO_VERSION...${NC}"

goenv install "$GO_VERSION" 2>/dev/null || echo "Go $GO_VERSION 已安装或安装失败"
goenv global "$GO_VERSION" 2>/dev/null || true

echo -e "${GREEN}✅ Go $GO_VERSION 已设置${NC}"

# 3. 安装 golangci-lint
if ! command -v golangci-lint &> /dev/null; then
    echo -e "${BLUE}📥 安装 golangci-lint...${NC}"
    $INSTALL_CMD golangci-lint
    echo -e "${GREEN}✅ golangci-lint 已安装${NC}"
else
    echo -e "${GREEN}✅ golangci-lint 已安装: $(golangci-lint --version | head -1)${NC}"
fi

# 4. 初始化项目
if [ ! -f "go.mod" ]; then
    echo -e "${YELLOW}⚠️ 未找到 go.mod${NC}"
    read -p "是否创建默认 Go 项目? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        # 询问模块路径
        read -p "模块路径 (如 github.com/user/project): " module_path
        if [ -z "$module_path" ]; then
            module_path="github.com/example/my-project"
        fi
        
        # 初始化模块
        go mod init "$module_path"
        
        # 创建目录结构
        mkdir -p cmd/server
        mkdir -p internal
        mkdir -p pkg
        mkdir -p api
        mkdir -p configs
        
        # 创建 main.go
        cat > cmd/server/main.go << 'EOF'
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello, Go!")
	})
	
	log.Println("Server starting on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
EOF
        
        # 创建示例 internal 包
        cat > internal/greeting/greeting.go << 'EOF'
package greeting

import "fmt"

// Greeter handles greetings
type Greeter struct {
	name string
}

// New creates a new Greeter
func New(name string) *Greeter {
	return &Greeter{name: name}
}

// Greet returns a greeting message
func (g *Greeter) Greet() string {
	return fmt.Sprintf("Hello, %s!", g.name)
}
EOF
        
        # 创建测试
        cat > internal/greeting/greeting_test.go << 'EOF'
package greeting

import "testing"

func TestGreeter_Greet(t *testing.T) {
	g := New("World")
	got := g.Greet()
	want := "Hello, World!"
	if got != want {
		t.Errorf("Greet() = %v, want %v", got, want)
	}
}
EOF
        
        # 创建 Makefile
        cat > Makefile << 'EOF'
.PHONY: build test lint clean run validate

# 变量
BINARY_NAME=server
BUILD_DIR=bin
CMD_DIR=cmd/server

# 构建
build:
	go build -o $(BUILD_DIR)/$(BINARY_NAME) ./$(CMD_DIR)

# 运行
run: build
	./$(BUILD_DIR)/$(BINARY_NAME)

# 测试
test:
	go test -race -coverprofile=coverage.out ./...
	go tool cover -func=coverage.out | grep total

# 代码检查
lint:
	golangci-lint run --timeout=5m

# 清理
clean:
	rm -rf $(BUILD_DIR)/
	rm -f coverage.out

# 完整验证
validate: lint test build
	@echo "✅ All validations passed!"

# 依赖管理
deps:
	go mod download
	go mod tidy

# 安装开发工具
tools:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
EOF
        
        # 创建 .golangci.yml
        cat > .golangci.yml << 'EOF'
run:
  timeout: 5m
  go: '1.21'

linters:
  enable:
    - errcheck
    - gosimple
    - govet
    - ineffassign
    - staticcheck
    - unused
    - gocritic
    - gofmt
    - goimports
    - misspell
    - revive

linters-settings:
  gocritic:
    enabled-tags:
      - performance
      - style

issues:
  exclude-use-default: false
EOF
        
        # 创建 .gitignore
        cat > .gitignore << 'EOF'
# Binaries
bin/
*.exe
*.dll
*.so
*.dylib

# Test binary
*.test

# Coverage
coverage.out
*.cov

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Dependencies (vendor if needed)
vendor/
EOF
        
        echo -e "${GREEN}✅ 已创建默认 Go 项目结构${NC}"
    fi
fi

# 5. 下载依赖
if [ -f "go.mod" ]; then
    echo -e "${BLUE}📦 下载依赖...${NC}"
    go mod download
    echo -e "${GREEN}✅ 依赖已下载${NC}"
fi

# 6. 验证安装
echo ""
echo -e "${BLUE}🔍 验证安装...${NC}"
echo "Go: $(go version)"
echo "golangci-lint: $(golangci-lint --version | head -1)"
if command -v goenv &> /dev/null; then
    echo ""
    echo "goenv 管理的 Go 版本:"
    goenv versions
fi

echo ""
echo "=============================="
echo -e "${GREEN}✅ Go 环境初始化完成！${NC}"
echo "=============================="
echo ""
echo "使用命令:"
echo "  make build     # 编译"
echo "  make run       # 运行"
echo "  make test      # 运行测试"
echo "  make lint      # 代码检查"
echo "  make validate  # 完整验证"
echo "  make clean     # 清理"
