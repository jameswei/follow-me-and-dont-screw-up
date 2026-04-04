# Phase 3: Implementation & Verification

## Environment Setup (Required Before Starting)

### 3.1 Run Environment Check

```bash
# 1. Run environment check script
./scripts/check-env.sh

# 2. If environment missing, run language-specific setup
./scripts/setup-python.sh      # Python (uv)
./scripts/setup-typescript.sh  # TypeScript (nvm + npm/bun)
./scripts/setup-java.sh        # Java (jenv + maven)
./scripts/setup-go.sh          # Go (goenv)

# 3. Verify toolchain
make validate  # or language-specific validation
```

### 3.2 Recommended Tool Version Managers

| Language | Version Manager | Package Manager | Verify Command |
|----------|-----------------|-----------------|----------------|
| Python | `uv` | `uv pip` | `uv --version` |
| TypeScript | `nvm` | `npm`/`bun` | `node --version` |
| Java | `jenv` | `maven` | `java --version` |
| Go | `goenv` | `go mod` | `go version` |

### 3.3 Docker Sandbox (Optional but Recommended)

```bash
# Start language-specific sandbox
docker-compose -f sandbox/docker-compose.yml up -d python-dev
docker-compose -f sandbox/docker-compose.yml up -d dev  # Multi-language

# Enter sandbox
docker-compose -f sandbox/docker-compose.yml exec dev bash
```

## 3.4 Pre-Implementation

After design confirmation, first create `docs/IMPLEMENTATION_PLAN.md`:

```markdown
# IMPLEMENTATION PLAN

## Task Breakdown
| No. | Task | Dependencies | Est. Time | Deliverable |
|-----|------|--------------|-----------|-------------|
| 1 | [Specific task] | [Prerequisites] | [Estimate] | [Verifiable output] |

## Implementation Order
[Explain why this order]

## Verification Checklist
- [ ] Each task independently verifiable
- [ ] Integration points identified
```

## 3.5 Coding Standards

Follow language-specific standards (see `instructions/languages/`).

### General Code Standards

**Naming**:
- Variables/Functions: Clear intent, avoid abbreviations (unless industry standard)
- Classes/Modules: Nouns, single responsibility
- Booleans: Use is/has/should/can prefix

**Function Design**:
- Single Responsibility: One function does one thing
- Parameter Count: ≤3, use config object/struct if more
- Return Values: Error as last return value (Go style) or use exceptions/Result
- Side Effects: Indicate in function name (e.g., `saveXxx`, `mutateXxx`)

**Comments**:
- Why > What > How
- Public APIs must have documentation comments
- Complex algorithms must explain principles

**Error Handling**:
- Error messages must include context (which operation, which entity)
- Distinguish user errors (4xx) from system errors (5xx)
- Log at error origin, wrap when propagating

## 3.6 Incremental Delivery

- After each feature point, proactively show code and request feedback
- NO large code dumps in single commit
- If design doesn't cover something, PAUSE and return to Phase 2

## 3.7 Verification Loop (Mandatory)

After EVERY code change, execute verification:

```
Step 1: Compilation/Type Check
   Command: tsc --noEmit / mypy . / go build / mvn compile
   On Fail: STOP, fix syntax errors

Step 2: Static Analysis
   Command: eslint . / ruff check . / golangci-lint run
   On Fail: Fix all Errors, evaluate Warnings

Step 3: Unit Tests
   Command: jest / pytest / go test / mvn test
   On Fail: Fix failing tests, add missing tests
   Target: Coverage ≥80%

Step 4: Code Review (Self-Review)
   Checklist:
   - [ ] Follows language standards
   - [ ] Naming is clear
   - [ ] Has appropriate comments
   - [ ] Error handling complete
   - [ ] No redundant code
```

## 3.8 PLAN.md Status Updates

During implementation, update task status in real-time:

```markdown
#### Task Detail: 1.1.1

**Implementation**: ✅ [2026-04-03 15:00]
**Verification**:
- Compilation: ✅ [Timestamp]
- Static Analysis: ✅ [Timestamp]
- Unit Test: 🔄 [Coverage: 75% → Target: 80%]
- Integration Test: ⬜

**Verification History**:
- [2026-04-03 15:00] First verification: Compilation failed, missing imports
- [2026-04-03 15:05] After fix: Compilation passed, test coverage insufficient
```

## Phase 3 Completion Criteria

Phase 3 ends when:
- [ ] All tasks in PLAN.md marked ✅
- [ ] All verification steps pass
- [ ] Code review checklist complete
- [ ] User confirms "Implementation complete, proceed to documentation"
