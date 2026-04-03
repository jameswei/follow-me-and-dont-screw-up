# Executable Skills
# 可执行技能集

> 可直接安装到 Coding Agent 的实用技能

## 简介

本目录包含可直接安装到 Claude Code、Codex、Cursor 等 AI Coding Agent 的实用技能。每个技能包含：

- **prompt.md** - 给 LLM 的完整指令
- **README.md** - 使用说明
- **示例** - 输入输出示例

## 可用技能

### 1. Code Review (代码审查)
系统性审查代码变更，识别问题并提供改进建议。

**触发条件**: 文件变更 > 50 行、提交前、用户请求

**审查维度**:
- 正确性 (Correctness) 🔴
- 可读性 (Readability) 🟡
- 可维护性 (Maintainability) 🟡
- 性能 (Performance) 🟢
- 安全 (Security) 🔴
- 规范 (Standards) 🟢

**安装**:
```bash
./install.sh code-review codex    # 安装到 Codex
./install.sh code-review cursor   # 安装到 Cursor
```

### 2. Test Generation (测试生成)
分析代码并自动生成测试用例，确保覆盖关键路径。

**触发条件**: 新功能完成、覆盖率 < 80%、用户请求

**测试策略**:
- Happy Path - 正常输入输出
- Boundary Values - 边界值测试
- Invalid Inputs - 无效输入处理
- Error Cases - 错误情况
- Edge Cases - 特殊情况

**安装**:
```bash
./install.sh test-generation codex
./install.sh test-generation cursor
```

### 3. Refactoring (重构)
识别代码坏味道，提供安全的重构方案。

**触发条件**: 代码坏味道、复杂度过高、用户请求优化

**重构技术**:
- 提取函数 (Extract Function)
- 内联函数 (Inline Function)
- 提取变量 (Extract Variable)
- 引入参数对象 (Introduce Parameter Object)
- 移除死代码 (Remove Dead Code)

**安装**:
```bash
./install.sh refactoring codex
./install.sh refactoring cursor
```

### 4. Static Analysis (静态分析)
执行静态分析工具，自动修复问题，直到满足质量要求。

**触发条件**: 代码保存、提交前、CI/CD 流程

**检查层级**:
1. 编译/类型检查 (阻塞性)
2. 格式化检查
3. Lint 检查
4. 安全扫描

**安装**:
```bash
./install.sh static-analysis codex
./install.sh static-analysis cursor
```

## 安装脚本

### 使用方法

```bash
./install.sh <skill-name> <agent-type>
```

### 参数

- `skill-name`: 技能名称 (code-review, test-generation, refactoring, static-analysis)
- `agent-type`: Agent 类型 (codex, cursor, claude)

### 示例

```bash
# 安装代码审查技能到 Codex
./install.sh code-review codex

# 安装测试生成技能到 Cursor
./install.sh test-generation cursor

# 查看帮助
./install.sh
```

## 手动安装

如果不想使用安装脚本，可以手动复制 prompt：

```bash
# 查看技能 prompt
cat code-review/prompt.md

# 手动添加到 Codex
cat code-review/prompt.md >> ~/.codex/instructions.md

# 手动添加到 Cursor
cat code-review/prompt.md >> ~/.cursorrules
```

## 自定义技能

### 创建新技能

1. 创建技能目录
```bash
mkdir my-skill
cd my-skill
```

2. 创建 README.md
```markdown
# My Skill

## 用途
描述技能用途

## 触发条件
什么时候使用

## 使用方式
如何使用
```

3. 创建 prompt.md
```markdown
# My Skill Prompt

## 角色定义
你是一位...

## 工作流程
1. 步骤一
2. 步骤二
3. 步骤三

## 输出格式
```
输出模板
```
```

4. 安装测试
```bash
./install.sh my-skill codex
```

## 最佳实践

### 1. 组合使用技能

多个技能可以组合使用：

```
代码变更 → Static Analysis → Code Review → Test Generation
```

### 2. 在项目中启用

在项目根目录创建 `.skills` 文件：

```
code-review
test-generation
static-analysis
```

Agent 会自动加载这些技能。

### 3. 版本控制

技能配置应该版本控制：

```bash
# 备份当前技能配置
cp ~/.codex/instructions.md .codex-instructions-backup.md
cp ~/.cursorrules .cursorrules-backup.md

# 提交到仓库
git add .codex-instructions-backup.md
git commit -m "backup: agent skills config"
```

## 故障排除

### 技能未生效

1. 检查是否正确安装
   ```bash
   grep "Skill: code-review" ~/.codex/instructions.md
   ```

2. 重启 Agent 或重新加载配置

3. 检查是否有语法错误

### 技能冲突

如果多个技能有冲突：

1. 调整技能顺序（后加载的覆盖先加载的）
2. 手动合并冲突部分
3. 创建自定义技能组合

## 贡献

欢迎贡献新的技能！请遵循以下规范：

1. 创建技能目录
2. 提供完整的 README.md 和 prompt.md
3. 包含使用示例
4. 测试通过后再提交

## 许可

与主项目相同
