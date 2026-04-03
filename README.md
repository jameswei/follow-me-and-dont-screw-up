# Follow Me And Don't Screw Up

> 个人 Coding Agent 工程规范与最佳实践指南

中文版本 | [English Version](./README_EN.md)

## 简介

本仓库包含用于指导 Claude Code、Codex、Cursor 等 AI Coding Agent 的完整工程规范。核心理念：

- **三阶段强制确认**: 需求澄清 → 设计产出 → 实现
- **文档优先**: 所有重要决策必须落盘
- **可度量标准**: 验收标准、覆盖率、性能指标
- **语言特定规范**: Java、Python、TypeScript、Go

## 仓库结构

```
follow-me-and-dont-screw-up/
├── README.md                    # 本文件
├── codex/
│   └── instructions.md          # OpenAI Codex 全局指令
├── cursor/
│   └── .cursorrules             # Cursor IDE 规则文件
├── shared/
│   ├── languages/
│   │   ├── java.md              # Java 代码规范
│   │   ├── python.md            # Python 代码规范
│   │   ├── typescript.md        # TypeScript 代码规范
│   │   └── go.md                # Go 代码规范
│   ├── templates/
│   │   └── PLAN.md              # 项目计划模板
│   ├── validation/
│   │   ├── validation-workflow.md  # 验证工作流
│   │   └── tool-recommendations.md # 推荐工具链
│   ├── skills/
│   │   └── skill-recommendations.md # 推荐技能
│   └── setup/
│       ├── environment-setup.md    # 环境准备指南
│       ├── scripts/                # 环境初始化脚本
│       │   ├── check-env.sh
│       │   ├── setup-python.sh
│       │   ├── setup-typescript.sh
│       │   ├── setup-java.sh
│       │   └── setup-go.sh
│       └── sandbox/                # Docker 沙盒环境
│           ├── Dockerfile
│           ├── Dockerfile.python
│           ├── Dockerfile.typescript
│           ├── Dockerfile.java
│           ├── Dockerfile.go
│           ├── docker-compose.yml
│           ├── devcontainer.json
│           └── README.md
└── en/                          # 英文版本
    ├── codex/
    │   └── instructions.md
    ├── cursor/
    │   └── .cursorrules
    └── shared/
        ├── languages/
        │   ├── java.md
        │   ├── python.md
        │   ├── typescript.md
        │   └── go.md
        └── templates/
            └── PLAN.md
```

## 快速开始

### 1. 安装配置

#### Codex (OpenAI)

```bash
# 全局配置
mkdir -p ~/.codex
cp codex/instructions.md ~/.codex/instructions.md

# 或在项目根目录
cp codex/instructions.md ./codex.md
```

#### Cursor

```bash
# 全局配置
cp cursor/.cursorrules ~/.cursorrules

# 或在项目根目录
cp cursor/.cursorrules ./.cursorrules
```

### 2. 新项目启动流程

启动任何项目时，Agent 会自动遵循以下流程：

```
┌─────────────────────────────────────────────────────────────┐
│  Phase 1: 需求澄清                                           │
│  - 输出需求理解摘要                                           │
│  - 提出澄清问题                                               │
│  - 用户确认"需求无误"                                         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Phase 2: 设计产出                                           │
│  - docs/PRD-SPEC.md        (需求规格)                        │
│  - docs/ARCHITECTURE.md    (架构设计)                        │
│  - docs/TEST_STRATEGY.md   (测试策略)                        │
│  - docs/PLAN.md            (项目计划)                         │
│  - 用户确认"设计无误"                                         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Phase 3: 实现                                               │
│  - docs/IMPLEMENTATION_PLAN.md (实现计划)                    │
│  - 增量交付，每步确认                                          │
│  - 实时更新 PLAN.md 状态                                      │
└─────────────────────────────────────────────────────────────┘
```

## 设计产出物模板

### PRD-SPEC.md

```markdown
# PRD-SPEC: [项目名称]

## 1. 概述
### 1.1 背景
### 1.2 目标
### 1.3 成功标准 (可度量)

## 2. 功能需求
### 2.1 用户故事
### 2.2 功能列表 (ID | 功能 | 优先级 | 验收标准)
### 2.3 非功能需求

## 3. 约束与假设
## 4. 风险分析
## 5. 术语表
```

### ARCHITECTURE.md

```markdown
# ARCHITECTURE: [项目名称]

## 1. 架构概述
## 2. 系统架构图
## 3. 组件设计
## 4. 数据设计
## 5. 接口设计
## 6. 质量属性设计 (可扩展性、可靠性、可观测性、安全性)
## 7. 决策记录 (ADR)
```

### TEST_STRATEGY.md

```markdown
# TEST STRATEGY: [项目名称]

## 1. 测试分层 (单元/集成/E2E)
## 2. 单元测试规范
## 3. 集成测试规范
## 4. 测试数据管理
```

### PLAN.md

```markdown
# PLAN: [项目名称]

## 任务总览
| 指标 | 数值 |
| 总任务数 | N |
| 已完成 | N (%) |
| 进行中 | N |
| 阻塞中 | N |

## 任务分解 (WBS)
| ID | 任务 | 状态 | 优先级 | 预计工时 | 依赖 | 产出物 |

## 依赖关系图
## 当前执行状态
## 变更日志
```

**PLAN.md 的作用：**
- **外置任务看板**: 将 LLM 的 reasoning 和 breakdown 固化到文件
- **上下文恢复检查点**: 中断后可从此恢复
- **可追踪进度**: 可度量的任务完成状态
- **唯一真相来源**: 所有工作必须在此跟踪

## 语言特定规范

| 语言 | 主要参考 | 关键特点 |
|------|---------|---------|
| Java | Google Java Style + Effective Java | final, Optional, 异常分层 |
| Python | PEP 8 + Google Python Style | 类型注解, dataclasses, Result 模式 |
| TypeScript | Google TS Style | strict 模式, 禁止 any, Result 类型 |
| Go | Effective Go + Uber Style | 显式错误处理, 小接口, context |

查看 `shared/languages/` 目录获取完整规范。

## 验证与工具链

### 验证工作流

代码实现后必须通过验证闭环：

```
编译检查 → 静态分析 → 单元测试 → 集成测试 → 代码审查
```

详见 `shared/validation/validation-workflow.md`

### 推荐工具链

按语言推荐的验证工具：

| 语言 | 类型检查 | 格式化 | Lint | 测试 | 安全 |
|------|---------|--------|------|------|------|
| TypeScript | `tsc` | `Prettier` | `ESLint` | `Jest` | `npm audit` |
| Python | `mypy` | `Black` | `ruff` | `pytest` | `bandit` |
| Go | `go build` | `gofmt` | `golangci-lint` | `go test` | `gosec` |
| Java | `javac` | `google-java-format` | `Checkstyle` | `JUnit` | `OWASP DC` |

详见 `shared/validation/tool-recommendations.md`

## 技能与扩展

### 核心技能

| 技能 | 用途 | 触发条件 |
|------|------|---------|
| 代码审查 | 系统性检查代码问题 | 每次 >50 行变更 |
| 重构建议 | 识别坏味道，提供方案 | 检测到代码异味 |
| 测试生成 | 自动生成测试用例 | 覆盖率 <80% |
| 文档生成 | 自动生成 API 文档 | 公共 API 变更 |

详见 `shared/skills/skill-recommendations.md`

## 环境准备

### 环境检查与初始化

项目启动前必须完成环境检查：

```bash
# 1. 运行环境检查
./scripts/check-env.sh

# 2. 根据项目类型初始化环境
./scripts/setup-python.sh      # Python (uv)
./scripts/setup-typescript.sh  # TypeScript (nvm + npm/bun)
./scripts/setup-java.sh        # Java (jenv + maven)
./scripts/setup-go.sh          # Go (goenv)
```

### 推荐工具版本管理

| 语言 | 版本管理器 | 包管理器 | 特点 |
|------|-----------|---------|------|
| Python | `uv` | `uv pip` | 极速、现代化 |
| TypeScript | `nvm` | `npm`/`bun` | 灵活、生态丰富 |
| Java | `jenv` | `maven` | 多版本 JDK 管理 |
| Go | `goenv` | `go mod` | 简洁、高效 |

详见 `shared/setup/environment-setup.md`

### Docker 沙盒环境

提供隔离的、可复现的开发环境：

```bash
# 启动特定语言沙盒
docker-compose -f sandbox/docker-compose.yml up -d python-dev
docker-compose -f sandbox/docker-compose.yml up -d typescript-dev

# 或者启动通用多语言沙盒
docker-compose -f sandbox/docker-compose.yml up -d dev

# 进入沙盒
docker-compose -f sandbox/docker-compose.yml exec dev bash
```

**沙盒类型**:
- 单语言 Dockerfile (轻量)
- 通用多语言 Dockerfile (一站式)
- Docker Compose (多服务编排)
- Dev Container (VS Code 集成)

详见 `shared/setup/sandbox/README.md`

## 关键原则

### 1. 禁止事项

- ❌ 直接开始写代码而不经过需求确认
- ❌ 设计未确认就进入实现
- ❌ 一次提交超过 200 行变更（不含测试）
- ❌ 使用 "TODO" 或 "FIXME" 而不创建跟踪任务
- ❌ 忽略编译器/静态分析警告
- ❌ 提交未测试的代码
- ❌ 在代码中硬编码配置
- ❌ 不更新 PLAN.md 状态就继续工作

### 2. 必须事项

- ✅ 每个阶段结束时明确询问"是否确认进入下一阶段"
- ✅ 所有设计文档使用 markdown 格式
- ✅ 验收标准必须可度量、可测试
- ✅ 公共 API 必须有文档注释
- ✅ 错误信息必须包含上下文
- ✅ 使用版本控制，小步提交
- ✅ 实现过程中实时更新 PLAN.md 状态

### 3. 沟通规范

- 使用中文与用户交流（除非用户要求英文）
- 遇到不确定的问题，立即询问而非猜测
- 进度汇报: 每完成一个里程碑，简要汇报完成情况
- 每次会话开始时读取 PLAN.md 确认当前任务

## 基于 PLAN.md 的上下文恢复

如果会话中断：

1. **读取 PLAN.md**: 了解当前任务状态
2. **检查最后更新时间**: 确认信息时效性
3. **验证已完成任务**: 快速检查产出物是否存在
4. **确认当前任务**: 明确接下来要做什么
5. **询问用户**: "根据 PLAN.md，当前任务是 [X]，是否继续？"

## 自定义与扩展

### 添加新语言规范

1. 在 `shared/languages/` 创建 `{language}.md`
2. 参考现有规范结构
3. 更新本 README 的语言表格

### 调整严格程度

编辑对应 agent 的配置文件：

- **更严格**: 增加检查项、降低覆盖率阈值
- **更宽松**: 移除非核心检查、提高阈值

### 项目特定覆盖

在项目根目录创建 `.coding-standards.md`：

```markdown
# 项目特定覆盖

## 覆盖全局规范
- 行长度限制: 120 字符（替代 100）
- 单元测试覆盖率: 70%（替代 80%）

## 项目特定规则
- 必须使用 PostgreSQL
- 禁止使用 ORM，使用原生 SQL
```

## 版本控制

```bash
# 初始化仓库
git init
git add .
git commit -m "Initial commit: coding standards v1.0"

# 推送到私有仓库
git remote add origin <your-private-repo>
git push -u origin main
```

## 更新日志

### v1.1 (2026-04-03)
- PLAN.md 模板，用于外置任务跟踪
- 所有文档的英文版本
- 增强上下文恢复流程

### v1.0 (2026-04-03)
- 初始版本
- 支持 Codex、Cursor 配置
- 包含 Java、Python、TypeScript、Go 规范
- 三阶段工作流定义

## 参考资源

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [PEP 8](https://peps.python.org/pep-0008/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
- [Effective Go](https://go.dev/doc/effective_go)
- [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)

---

**记住**: 这些规范是工具，不是教条。根据项目实际情况灵活调整，但核心原则（文档优先、三阶段确认）不应妥协。
