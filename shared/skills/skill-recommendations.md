# 推荐技能与扩展 (Recommended Skills & Extensions)
# 位置: shared/skills/skill-recommendations.md
# 用途: 推荐可扩展 Agent 能力的技能和工具

# =============================================================================
# 核心概念: Tools vs Skills
# =============================================================================

## 定义区分

| 概念 | 定义 | 示例 | 适用场景 |
|------|------|------|---------|
| **Tools** | 外部可执行程序，Agent 调用获取结果 | 编译器、Linter、测试框架 | 验证、分析、构建 |
| **Skills** | Agent 内部能力模块，封装特定领域知识 | 代码审查、重构建议、文档生成 | 决策、推理、生成 |

## 关系

```
┌─────────────────────────────────────────────────────────────┐
│                      Agent Core                              │
│                   (LLM + Context)                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────┼─────────────────────┐
        ↓                     ↓                     ↓
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│   Skills      │    │    Tools      │    │  Memory       │
│  (内部能力)    │    │  (外部工具)    │    │  (持久化)      │
│               │    │               │    │               │
│ • Code Review │    │ • Compiler    │    │ • PLAN.md     │
│ • Refactor    │    │ • Linter      │    │ • Memory      │
│ • Doc Gen     │    │ • Test Runner │    │ • Learnings   │
└───────────────┘    └───────────────┘    └───────────────┘
```

# =============================================================================
# 核心技能 (Core Skills)
# =============================================================================

## 1. 代码审查 (Code Review)

### 能力描述
系统性分析代码变更，识别问题，提供改进建议。

### 审查维度

| 维度 | 检查内容 | 严重程度 |
|------|---------|---------|
| **正确性** | 逻辑错误、边界条件、并发问题 | 🔴 阻塞 |
| **可读性** | 命名、注释、复杂度、长度 | 🟡 高 |
| **可维护性** | 耦合度、重复、测试覆盖 | 🟡 高 |
| **性能** | 算法复杂度、资源使用 | 🟢 中 |
| **安全** | 注入、越界、敏感数据 | 🔴 阻塞 |
| **规范** | 风格、最佳实践 | 🟢 低 |

### 审查清单模板

```markdown
## Code Review: [PR/变更描述]

### 变更摘要
- 文件数: [N]
- 新增行: [N]
- 删除行: [N]
- 测试覆盖: [X%]

### 审查结果

#### 🔴 阻塞问题 (必须修复)
1. [问题描述] @ [文件:行号]
   - 影响: [具体影响]
   - 建议: [修复方案]

#### 🟡 高优先级 (建议修复)
1. [问题描述] @ [文件:行号]
   - 建议: [改进方案]

#### 🟢 建议 (可选)
1. [建议描述]

### 整体评价
- [ ] 批准 (无阻塞问题)
- [ ] 有条件批准 (需修复阻塞问题)
- [ ] 需要修改 (需重新审查)
```

### 与工具结合

```bash
# 1. 获取变更
git diff HEAD~1

# 2. 运行静态分析
eslint . --format=json

# 3. 运行测试
npm test -- --coverage

# 4. Agent 综合分析
# 结合 diff + lint 结果 + 覆盖率报告 → 审查意见
```

## 2. 重构建议 (Refactoring)

### 能力描述
识别代码坏味道，提供重构方案，执行安全重构。

### 重构触发条件

| 坏味道 | 检测指标 | 重构方案 |
|--------|---------|---------|
| 长函数 | >30 行 | 提取函数 |
| 大类 | >200 行 / >10 方法 | 拆分职责 |
| 重复代码 | >3 处相似 | 提取抽象 |
| 深层嵌套 | >3 层 | 提前返回/卫语句 |
| 魔法数字 | 字面量多次出现 | 提取常量 |
| 长参数 | >3 参数 | 参数对象 |

### 安全重构流程

```
1. 识别重构目标
   ↓
2. 检查测试覆盖
   ↓ 覆盖不足 → 先补充测试
3. 应用重构
   ↓
4. 运行测试验证
   ↓ 失败 → 回滚，检查原因
5. 代码审查
   ↓
6. 提交变更
```

### 自动化重构工具

| 语言 | 工具 | 能力 |
|------|------|------|
| TypeScript | `ts-morph` | AST 操作 |
| Python | `rope` / `libcst` | 重构库 |
| Java | IDE 重构 / `spoon` | 代码转换 |
| Go | `gopls` | 语言服务器重构 |

## 3. 测试生成 (Test Generation)

### 能力描述
分析代码，自动生成测试用例，确保覆盖关键路径。

### 生成策略

| 策略 | 适用场景 | 工具/方法 |
|------|---------|----------|
| 基于契约 | 接口/API 测试 | 属性测试、模糊测试 |
| 基于路径 | 分支覆盖 | 符号执行、约束求解 |
| 基于示例 | 数据驱动 | 参数化测试模板 |
| 基于变更 | 回归测试 | 变更影响分析 |

### 测试模板生成

```typescript
// 输入: 函数签名
function calculateDiscount(price: number, rate: number): number

// 输出: 测试模板
describe('calculateDiscount', () => {
  it('should calculate discount for normal case', () => {
    // TODO: Implement
    // Input: price=100, rate=0.1
    // Expected: 90
  });
  
  it('should handle zero price', () => {
    // TODO: Implement
    // Input: price=0, rate=0.1
    // Expected: Error or 0
  });
  
  it('should handle invalid rate', () => {
    // TODO: Implement
    // Input: price=100, rate=-0.1
    // Expected: Error
  });
  
  it('should handle rate > 1', () => {
    // TODO: Implement
    // Input: price=100, rate=1.5
    // Expected: Error
  });
});
```

## 4. 文档生成 (Documentation Generation)

### 能力描述
从代码中提取信息，生成 API 文档、架构图、变更日志。

### 文档类型

| 类型 | 来源 | 工具 | 输出 |
|------|------|------|------|
| API 文档 | 代码注释 | TypeDoc/Swagger/Javadoc | HTML/Markdown |
| 架构图 | 模块依赖 | `dependency-cruiser` / `pyreverse` | Mermaid/DOT |
| 变更日志 | Git 历史 | `conventional-changelog` | CHANGELOG.md |
| 指标报告 | 测试/分析 | 自定义脚本 | Markdown |

### 架构图自动生成

```bash
# TypeScript
npx dependency-cruiser src --output-type mermaid

# Python
pyreverse -o mermaid src/

# Go
godepgraph -s ./... | dot -Tpng > deps.png
```

# =============================================================================
# 扩展技能 (Extension Skills)
# =============================================================================

## 5. 性能分析 (Performance Analysis)

### 能力
- 识别性能瓶颈
- 建议优化方案
- 生成性能报告

### 工具集成

| 语言 | 分析工具 | 能力 |
|------|---------|------|
| TypeScript | `clinic.js` / `0x` | 火焰图分析 |
| Python | `cProfile` / `py-spy` | CPU/内存分析 |
| Go | `pprof` | 内置性能分析 |
| Java | `async-profiler` / JFR | 综合性能分析 |

## 6. 安全审计 (Security Audit)

### 能力
- 识别常见漏洞
- 检查依赖安全
- 合规性检查

### 工具集成

| 类型 | 工具 | 覆盖 |
|------|------|------|
| SAST | `semgrep` / `CodeQL` | 源码漏洞 |
| DAST | `OWASP ZAP` | 运行时漏洞 |
| SCA | `Snyk` / `Dependabot` | 依赖漏洞 |
| Secret | `git-secrets` / `truffleHog` | 密钥泄露 |

## 7. 依赖管理 (Dependency Management)

### 能力
- 分析依赖树
- 检测过时依赖
- 建议升级方案

### 工具

```bash
# TypeScript
npm outdated
npm audit

# Python
pip list --outdated
pip-audit

# Go
go list -u -m all
govulncheck ./...
```

# =============================================================================
# Skill 开发指南
# =============================================================================

## 创建新 Skill 的步骤

### 1. 定义 Skill 接口

```typescript
interface Skill {
  name: string;
  description: string;
  triggers: string[];      // 触发关键词
  requiredTools: string[]; // 依赖的外部工具
  inputSchema: object;     // 输入参数结构
  outputSchema: object;    // 输出结果结构
}

// 示例: 代码审查 Skill
const codeReviewSkill: Skill = {
  name: "code-review",
  description: "系统性代码审查，识别问题并提供建议",
  triggers: ["review", "审查", "code review"],
  requiredTools: ["git", "eslint", "jest"],
  inputSchema: {
    type: "object",
    properties: {
      diff: { type: "string" },
      files: { type: "array", items: { type: "string" } },
      context: { type: "string" }
    }
  },
  outputSchema: {
    type: "object",
    properties: {
      issues: { type: "array" },
      summary: { type: "string" },
      approval: { type: "boolean" }
    }
  }
};
```

### 2. 实现 Skill 逻辑

```typescript
class CodeReviewSkill implements SkillExecutor {
  async execute(input: SkillInput): Promise<SkillOutput> {
    // 1. 收集信息
    const diff = await this.getDiff(input.files);
    const lintResults = await this.runLinter(input.files);
    const testResults = await this.runTests(input.files);
    
    // 2. LLM 分析
    const analysis = await this.llm.analyze({
      diff,
      lintResults,
      testResults,
      context: input.context
    });
    
    // 3. 格式化输出
    return this.formatReview(analysis);
  }
}
```

### 3. 注册 Skill

```typescript
// 在 Agent 配置中注册
const agentConfig = {
  skills: [
    new CodeReviewSkill(),
    new RefactoringSkill(),
    new TestGenerationSkill(),
    // ...
  ]
};
```

## Skill 组合模式

### 工作流组合

```
代码变更触发
    ↓
┌─────────────────┐
│ 1. 静态分析 Skill │ → Lint 结果
└─────────────────┘
    ↓
┌─────────────────┐
│ 2. 测试运行 Skill │ → 测试结果
└─────────────────┘
    ↓
┌─────────────────┐
│ 3. 代码审查 Skill │ → 审查报告
└─────────────────┘
    ↓
┌─────────────────┐
│ 4. 文档更新 Skill │ → 更新文档
└─────────────────┘
```

### 条件触发

```typescript
// 根据上下文自动选择 Skill
function selectSkills(context: Context): Skill[] {
  const skills: Skill[] = [];
  
  if (context.hasCodeChanges) {
    skills.push(new ValidationSkill());
  }
  
  if (context.testCoverage < 0.8) {
    skills.push(new TestGenerationSkill());
  }
  
  if (context.linesChanged > 100) {
    skills.push(new CodeReviewSkill());
  }
  
  return skills;
}
```

# =============================================================================
# 与现有规范集成
# =============================================================================

## 在 PLAN.md 中跟踪 Skill 使用

```markdown
#### 任务详情: 1.1.1

**实现**: ✅ [时间戳]
**验证**: ✅ [时间戳]
**技能应用**:
- [x] 代码审查: [审查结果链接]
- [x] 测试生成: [新增测试覆盖率: 85%]
- [ ] 性能分析: [N/A - 非性能敏感代码]

**质量指标**:
- 复杂度: [N] (目标: <10)
- 重复率: [N%] (目标: <5%)
- 文档覆盖率: [N%] (目标: 100% public API)
```

## 在 Agent 指令中引用 Skill

```markdown
## 可用技能

当执行以下任务时，使用对应的技能：

1. **代码审查**: 任何 >50 行的变更
   - 使用: `CodeReviewSkill`
   - 输出: 审查报告，阻塞问题列表

2. **测试生成**: 覆盖率 <80% 的模块
   - 使用: `TestGenerationSkill`
   - 输出: 测试文件，覆盖率报告

3. **重构建议**: 检测到代码坏味道
   - 使用: `RefactoringSkill`
   - 输出: 重构方案，风险评估
```

# =============================================================================
# 推荐技能优先级
# =============================================================================

## 必装技能 (P0)

1. **验证工作流** - 确保代码质量的基础
2. **代码审查** - 防止明显问题进入代码库
3. **测试生成** - 保障测试覆盖

## 推荐技能 (P1)

4. **重构建议** - 持续改进代码质量
5. **文档生成** - 降低维护成本
6. **依赖管理** - 安全保障

## 进阶技能 (P2)

7. **性能分析** - 性能敏感项目
8. **安全审计** - 高安全要求项目
9. **架构分析** - 大型项目维护

# =============================================================================
# 工具与技能对照表
# =============================================================================

| 需求 | 首选工具 | 辅助 Skill | 输出 |
|------|---------|-----------|------|
| 编译检查 | 编译器 | - | 通过/失败 |
| 类型检查 | tsc/mypy | - | 错误列表 |
| 代码风格 | Prettier/Black | 格式化 Skill | 修复后的代码 |
| 代码质量 | ESLint/ruff | 代码审查 Skill | 问题报告 |
| 测试运行 | Jest/pytest | 测试生成 Skill | 测试结果 |
| 覆盖率 | 覆盖率工具 | 测试生成 Skill | 覆盖率报告 |
| 安全扫描 | Snyk/bandit | 安全审计 Skill | 漏洞报告 |
| 性能分析 | pprof/clinic | 性能分析 Skill | 优化建议 |
| 文档生成 | TypeDoc/Swagger | 文档生成 Skill | API 文档 |

# =============================================================================
# 总结
# =============================================================================

**Tools** 提供客观数据，**Skills** 提供智能决策。

最佳实践：
1. 先用 Tools 收集数据
2. 再用 Skills 分析决策
3. 结合两者生成可执行方案
4. 通过 Tools 验证执行结果

```
Tools → Data → Skills → Decision → Tools → Validation
```
