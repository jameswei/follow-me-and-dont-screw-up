# 推荐工具链 (Recommended Toolchain)
# 位置: shared/validation/tool-recommendations.md
# 用途: 按语言和场景推荐验证工具

# =============================================================================
# 工具选择原则
# =============================================================================

1. **单一职责**: 每个工具只做一件事，做好一件事
2. **生态活跃**: 持续维护，社区广泛采用
3. **可自动化**: 支持命令行，退出码明确，输出可解析
4. **Agent 友好**: 错误信息清晰，有修复建议

# =============================================================================
# TypeScript / JavaScript
# =============================================================================

## 核心工具链

| 环节 | 工具 | 用途 | 安装 | 配置 |
|------|------|------|------|------|
| 编译/类型 | TypeScript (`tsc`) | 类型检查 | `npm i -D typescript` | `tsconfig.json` |
| 格式化 | Prettier | 代码格式化 | `npm i -D prettier` | `.prettierrc` |
| Lint | ESLint | 代码质量 | `npm i -D eslint` | `.eslintrc` |
| 测试 | Jest / Vitest | 单元测试 | `npm i -D jest` | `jest.config.js` |
| 类型测试 | `tsd` | 类型定义测试 | `npm i -D tsd` | - |
| 安全 | `npm audit` / Snyk | 依赖安全 | 内置 / `npm i -D snyk` | - |

## 推荐配置

### package.json

```json
{
  "scripts": {
    "validate": "npm run validate:types && npm run validate:lint && npm run validate:test",
    "validate:types": "tsc --noEmit",
    "validate:lint": "eslint . --ext .ts,.tsx --max-warnings=0",
    "validate:test": "jest --coverage --coverageThreshold='{\"global\":{\"branches\":80,\"functions\":80,\"lines\":80,\"statements\":80}}'",
    "validate:fix": "prettier --write . && eslint --fix .",
    "validate:security": "npm audit --audit-level=moderate"
  }
}
```

### tsconfig.json (严格模式)

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  }
}
```

## 进阶工具

| 工具 | 用途 | 何时使用 |
|------|------|---------|
| `eslint-plugin-security` | 安全规则 | 所有项目 |
| `eslint-plugin-import` | 导入检查 | 大型项目 |
| `@typescript-eslint` | TS 专用规则 | 所有 TS 项目 |
| `husky` + `lint-staged` | 提交前检查 | 团队协作 |
| `knip` | 检测未使用代码/导出 | 维护阶段 |

# =============================================================================
# Python
# =============================================================================

## 核心工具链

| 环节 | 工具 | 用途 | 安装 | 配置 |
|------|------|------|------|------|
| 类型检查 | mypy | 静态类型分析 | `pip install mypy` | `pyproject.toml` |
| 格式化 | Black | 代码格式化 | `pip install black` | `pyproject.toml` |
| 导入排序 | isort | 导入语句排序 | `pip install isort` | `pyproject.toml` |
| Lint | ruff | 快速 Python linter | `pip install ruff` | `pyproject.toml` |
| 测试 | pytest | 单元测试 | `pip install pytest` | `pytest.ini` |
| 覆盖率 | pytest-cov | 测试覆盖率 | `pip install pytest-cov` | `pyproject.toml` |
| 安全 | bandit | 安全漏洞扫描 | `pip install bandit` | - |
| 依赖 | pip-audit | 依赖安全检查 | `pip install pip-audit` | - |

## 推荐配置

### pyproject.toml

```toml
[project]
requires-python = ">=3.11"

[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W", "UP", "B", "C4", "SIM"]
ignore = ["E501"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "-v --tb=short"

[tool.coverage.run]
source = ["src"]
branch = true

[tool.coverage.report]
fail_under = 80
show_missing = true
skip_covered = false
```

### 验证脚本

```toml
[tool.taskipy.tasks]
validate = "task validate:types && task validate:lint && task validate:test"
validate_types = "mypy src"
validate_lint = "ruff check src tests"
validate_format = "black --check src tests && isort --check src tests"
validate_test = "pytest --cov=src --cov-report=term-missing --cov-fail-under=80"
validate_security = "bandit -r src && pip-audit"
validate_fix = "black src tests && isort src tests && ruff check src tests --fix"
```

## 进阶工具

| 工具 | 用途 | 何时使用 |
|------|------|---------|
| `pylint` | 深度代码分析 | 需要更严格检查时 |
| `pydantic` | 运行时类型验证 | 数据验证场景 |
| `hypothesis` | 属性测试 | 复杂算法测试 |
| `mutmut` | 变异测试 | 测试质量评估 |
| `vulture` | 死代码检测 | 维护阶段 |

# =============================================================================
# Go
# =============================================================================

## 核心工具链

| 环节 | 工具 | 用途 | 安装 | 配置 |
|------|------|------|------|------|
| 编译 | `go build` | 编译检查 | 内置 | - |
| 格式化 | `gofmt` / `goimports` | 代码格式化 | 内置 / `go install` | - |
| Lint | `golangci-lint` | 综合 linter | 二进制安装 | `.golangci.yml` |
| 测试 | `go test` | 单元测试 | 内置 | - |
| 覆盖率 | `go test -cover` | 测试覆盖率 | 内置 | - |
| 安全 | `gosec` | 安全扫描 | `go install` | - |
| 漏洞 | `govulncheck` | 漏洞检查 | `go install` | - |

## 推荐配置

### Makefile

```makefile
.PHONY: validate validate-compile validate-lint validate-test validate-fix validate-security

validate: validate-compile validate-lint validate-test validate-security

validate-compile:
	go build -v ./...

validate-lint:
	golangci-lint run --timeout=5m

validate-test:
	go test -race -coverprofile=coverage.out ./...
	go tool cover -func=coverage.out | grep total | awk '{print $$3}' | sed 's/%//' | awk '{if($$1<80) exit 1}'

validate-fix:
	gofmt -w .
	goimports -w .
	golangci-lint run --fix

validate-security:
	gosec ./...
	govulncheck ./...
```

### .golangci.yml

```yaml
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
    - errname
    - errorlint

linters-settings:
  gocritic:
    enabled-tags:
      - performance
      - style
      - experimental
  revive:
    rules:
      - name: exported
        arguments: [checkPrivateReceivers, sayRepetitiveInsteadOfStutters]

issues:
  exclude-use-default: false
```

## 进阶工具

| 工具 | 用途 | 何时使用 |
|------|------|---------|
| `go-critic` | 代码分析 | 包含在 golangci-lint |
| `staticcheck` | 静态分析 | 包含在 golangci-lint |
| `fieldalignment` | 结构体内存优化 | 性能敏感场景 |
| `go-mod-outdated` | 依赖更新检查 | 维护阶段 |

# =============================================================================
# Java
# =============================================================================

## 核心工具链

| 环节 | 工具 | 用途 | 安装 | 配置 |
|------|------|------|------|------|
| 编译 | `javac` / Maven / Gradle | 编译 | 内置 | `pom.xml` / `build.gradle` |
| 格式化 | `google-java-format` | 代码格式化 | 二进制 / Maven | - |
| Lint | Checkstyle / SpotBugs | 代码质量 | Maven/Gradle 插件 | XML 配置 |
| 测试 | JUnit 5 | 单元测试 | Maven/Gradle | - |
| 覆盖率 | JaCoCo | 测试覆盖率 | Maven/Gradle 插件 | - |
| 安全 | OWASP Dependency-Check | 依赖安全 | Maven/Gradle 插件 | - |

## 推荐配置 (Maven)

### pom.xml

```xml
<build>
  <plugins>
    <!-- 编译 -->
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.11.0</version>
      <configuration>
        <release>21</release>
      </configuration>
    </plugin>
    
    <!-- 测试 -->
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-plugin</artifactId>
      <version>3.1.2</version>
    </plugin>
    
    <!-- 覆盖率 -->
    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <version>0.8.11</version>
      <executions>
        <execution>
          <goals>
            <goal>prepare-agent</goal>
          </goals>
        </execution>
        <execution>
          <id>report</id>
          <phase>test</phase>
          <goals>
            <goal>report</goal>
          </goals>
        </execution>
        <execution>
          <id>check</id>
          <goals>
            <goal>check</goal>
          </goals>
          <configuration>
            <rules>
              <rule>
                <limits>
                  <limit>
                    <counter>LINE</counter>
                    <value>COVEREDRATIO</value>
                    <minimum>0.80</minimum>
                  </limit>
                </limits>
              </rule>
            </rules>
          </configuration>
        </execution>
      </executions>
    </plugin>
    
    <!-- 代码质量 -->
    <plugin>
      <groupId>com.github.spotbugs</groupId>
      <artifactId>spotbugs-maven-plugin</artifactId>
      <version>4.8.2.0</version>
    </plugin>
    
    <!-- 安全 -->
    <plugin>
      <groupId>org.owasp</groupId>
      <artifactId>dependency-check-maven</artifactId>
      <version>9.0.2</version>
    </plugin>
  </plugins>
</build>
```

## 进阶工具

| 工具 | 用途 | 何时使用 |
|------|------|---------|
| `PMD` | 代码分析 | 复杂项目 |
| `Error Prone` | 编译时错误检查 | Google 风格项目 |
| `NullAway` | 空指针检查 | 需要空安全时 |
| `SonarQube` | 综合质量平台 | 团队 CI/CD |

# =============================================================================
# 通用工具 (语言无关)
# =============================================================================

## 版本控制

| 工具 | 用途 | 推荐配置 |
|------|------|---------|
| Git | 版本控制 | 提交前钩子运行验证 |
| `git-secrets` | 防止密钥提交 | 所有项目 |
| `talisman` | 敏感信息检测 | 企业环境 |

## CI/CD

| 平台 | 用途 | 推荐 |
|------|------|------|
| GitHub Actions | CI/CD | 开源项目 |
| GitLab CI | CI/CD | GitLab 用户 |
| CircleCI | CI/CD | 快速启动 |
| Jenkins | 自托管 CI | 企业环境 |

## 容器

| 工具 | 用途 | 场景 |
|------|------|------|
| Docker | 容器化 | 部署、测试隔离 |
| Docker Compose | 多服务编排 | 集成测试 |
| Testcontainers | 测试容器 | 数据库测试 |

## 文档

| 工具 | 用途 | 场景 |
|------|------|------|
| `markdownlint` | Markdown 规范 | 文档项目 |
| `vale` | 文档风格检查 | 技术写作 |

# =============================================================================
# Agent 工具使用指南
# =============================================================================

## 命令执行模板

### TypeScript 项目

```bash
# 快速验证（开发中）
npm run validate:types  # 仅类型检查

# 完整验证（提交前）
npm run validate

# 自动修复
npm run validate:fix
```

### Python 项目

```bash
# 快速验证
task validate_types

# 完整验证
task validate

# 自动修复
task validate_fix
```

### Go 项目

```bash
# 快速验证
go build ./...

# 完整验证
make validate

# 自动修复
make validate-fix
```

## 输出解析

### 成功标准

| 工具 | 成功退出码 | 失败退出码 |
|------|-----------|-----------|
| `tsc` | 0 | 1-2 |
| `eslint` | 0 | 1 |
| `jest` | 0 | 1 |
| `mypy` | 0 | 1 |
| `pytest` | 0 | 1-5 |
| `go test` | 0 | 1 |
| `golangci-lint` | 0 | 1 |

### 错误信息提取

```python
# 示例: 解析 ESLint JSON 输出
import json
import subprocess

result = subprocess.run(
    ["eslint", ".", "--format", "json"],
    capture_output=True,
    text=True
)

if result.returncode != 0:
    errors = json.loads(result.stdout)
    for file in errors:
        if file["messages"]:
            print(f"File: {file['filePath']}")
            for msg in file["messages"]:
                print(f"  Line {msg['line']}: {msg['message']}")
```

## 工具缺失处理

### 检测工具安装

```bash
#!/bin/bash
# check-tools.sh

tools=("node" "npm" "python" "go" "docker")
missing=()

for tool in "${tools[@]}"; do
  if ! command -v "$tool" &> /dev/null; then
    missing+=("$tool")
  fi
done

if [ ${#missing[@]} -ne 0 ]; then
  echo "Missing tools: ${missing[*]}"
  exit 1
fi
```

### 自动安装建议

```
检测到 [tool] 未安装。

安装命令:
- macOS: brew install [tool]
- Ubuntu: apt-get install [tool]
- 通用: [官方安装命令]

是否自动安装？(Y/n)
```
