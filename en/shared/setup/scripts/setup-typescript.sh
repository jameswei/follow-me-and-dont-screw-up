#!/bin/bash
# setup-typescript.sh - TypeScript 环境初始化脚本 (使用 nvm + npm/bun)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📘 TypeScript 环境初始化${NC}"
echo "=============================="

# 1. 检查/安装 nvm
if ! command -v nvm &> /dev/null; then
    echo -e "${YELLOW}⚠️ nvm 未安装，正在安装...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # 加载 nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if ! command -v nvm &> /dev/null; then
        echo -e "${RED}❌ nvm 安装失败${NC}"
        echo "请手动安装: https://github.com/nvm-sh/nvm"
        exit 1
    fi
    echo -e "${GREEN}✅ nvm 安装成功${NC}"
else
    echo -e "${GREEN}✅ nvm 已安装: $(nvm --version)${NC}"
fi

# 确保 nvm 已加载
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 2. 安装 Node.js
NODE_VERSION="${NODE_VERSION:-20}"
echo -e "${BLUE}📥 安装 Node.js $NODE_VERSION...${NC}"
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
echo -e "${GREEN}✅ Node.js $(node --version) 已激活${NC}"

# 3. 可选: 安装 bun
if ! command -v bun &> /dev/null; then
    read -p "是否安装 bun (更快的包管理器)? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}📥 安装 bun...${NC}"
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
        echo -e "${GREEN}✅ bun 安装成功: $(bun --version)${NC}"
    fi
else
    echo -e "${GREEN}✅ bun 已安装: $(bun --version)${NC}"
fi

# 确定包管理器
if command -v bun &> /dev/null; then
    PKG_MGR="bun"
    PKG_INSTALL="bun install"
    PKG_RUN="bun run"
    PKG_EXEC="bunx"
else
    PKG_MGR="npm"
    PKG_INSTALL="npm install"
    PKG_RUN="npm run"
    PKG_EXEC="npx"
fi

echo -e "${BLUE}📦 使用包管理器: $PKG_MGR${NC}"

# 4. 初始化项目
if [ ! -f "package.json" ]; then
    echo -e "${YELLOW}⚠️ 未找到 package.json${NC}"
    read -p "是否创建默认 TypeScript 项目? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        # 初始化 package.json
        if [ "$PKG_MGR" = "bun" ]; then
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
    "start": "node dist/index.js",
    "test": "vitest",
    "test:ui": "vitest --ui",
    "lint": "eslint . --ext .ts,.tsx",
    "lint:fix": "eslint . --ext .ts,.tsx --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit",
    "validate": "npm run typecheck && npm run lint && npm run test"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "tsx": "^4.0.0",
    "typescript": "^5.0.0",
    "vitest": "^1.0.0"
  }
}
EOF
        
        # 创建目录结构
        mkdir -p src
        mkdir -p tests
        
        # 创建 tsconfig.json
        cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
        
        # 创建 ESLint 配置
        cat > .eslintrc.json << 'EOF'
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "project": "./tsconfig.json"
  },
  "plugins": ["@typescript-eslint"],
  "root": true
}
EOF
        
        # 创建 Prettier 配置
        cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
EOF
        
        # 创建示例文件
        cat > src/index.ts << 'EOF'
export function greet(name: string): string {
  return `Hello, ${name}!`;
}

if (import.meta.main) {
  console.log(greet('World'));
}
EOF
        
        cat > tests/index.test.ts << 'EOF'
import { describe, it, expect } from 'vitest';
import { greet } from '../src/index';

describe('greet', () => {
  it('should greet with name', () => {
    expect(greet('TypeScript')).toBe('Hello, TypeScript!');
  });
});
EOF
        
        echo -e "${GREEN}✅ 已创建默认 TypeScript 项目结构${NC}"
    fi
fi

# 5. 安装依赖
if [ -f "package.json" ]; then
    if [ ! -d "node_modules" ]; then
        echo -e "${BLUE}📦 安装依赖...${NC}"
        $PKG_INSTALL
        echo -e "${GREEN}✅ 依赖已安装${NC}"
    else
        echo -e "${GREEN}✅ 依赖已存在${NC}"
    fi
fi

# 6. 验证安装
echo ""
echo -e "${BLUE}🔍 验证安装...${NC}"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
if command -v bun &> /dev/null; then
    echo "bun: $(bun --version)"
fi

echo ""
echo "=============================="
echo -e "${GREEN}✅ TypeScript 环境初始化完成！${NC}"
echo "=============================="
echo ""
echo "使用命令:"
echo "  $PKG_RUN dev      # 开发模式 (热重载)"
echo "  $PKG_RUN build    # 编译"
echo "  $PKG_RUN test     # 运行测试"
echo "  $PKG_RUN lint     # 代码检查"
echo "  $PKG_RUN format   # 代码格式化"
echo "  $PKG_RUN validate # 完整验证"
