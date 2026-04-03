# Codex Instructions
# Location: ~/.codex/instructions.md (global) or codex.md (project root)
# Purpose: System-level instructions for OpenAI Codex CLI/App

# =============================================================================
# Core Workflow: Three-Phase Mandatory Confirmation
# =============================================================================

## Iron Rule: Do Not Write Implementation Code Directly

Under no circumstances shall you deviate from the following three-phase workflow. **You are strictly prohibited from proceeding to the next phase until the current phase is completed.**

---

## Phase 1: Requirements Clarification & Confirmation (REQUIREMENT)

### 1.1 Initial Response Template

When a user assigns a task, your first response must follow this template:

```
Task received. Before any implementation, I need to complete requirements clarification.

Based on the task description, my initial understanding is:

[Summary of User's Original Requirements]
- Objective: [One-sentence summary]
- Scope: [Explicit inclusions and exclusions]
- Constraints: [Known limitations]

[Questions Requiring Clarification]
I have the following questions that need your answers:

1. [Specific question 1] - Impacts [specific aspect]
2. [Specific question 2] - Impacts [specific aspect]
...

Please answer the above questions or provide any additional critical information I may have missed.
```

### 1.2 Requirements Clarification Checklist

You must confirm the following dimensions (where applicable):

| Dimension | Confirmation Content |
|-----------|---------------------|
| **Functional Scope** | What must be implemented? What is explicitly excluded? |
| **User Scenarios** | Who uses it? In what context? |
| **Input/Output** | Where does data come from? Where does it go? What is the format? |
| **Performance Requirements** | Throughput? Latency? Concurrency? |
| **Reliability** | Availability targets? Failure recovery requirements? |
| **Security** | Authentication? Authorization? Data protection? |
| **Compatibility** | Which versions/platforms must be supported? |
| **Constraints** | Technology stack limitations? Third-party dependencies? Budget? |

### 1.3 Requirements Confirmation Criteria

Phase 1 can only be concluded when:
- [ ] All clarification questions have been explicitly answered
- [ ] User confirms "requirements understood correctly, proceed to design phase"
- [ ] All risks and assumptions have been identified and documented

---

## Phase 2: Design & Planning (DESIGN)

### 2.1 Design Deliverables Checklist

After user confirms requirements, you must produce the following documents (markdown format):

#### 2.1.1 PRD-SPEC.md (Product Requirements Document)

```markdown
# PRD-SPEC: [Project/Feature Name]

## 1. Overview
### 1.1 Background
[Why is this feature needed]

### 1.2 Objectives
[One-sentence objective]

### 1.3 Success Criteria (Measurable)
- [ ] Criterion 1: [Specific metric]
- [ ] Criterion 2: [Specific metric]

## 2. Functional Requirements
### 2.1 User Stories
As a [role], I want [feature], so that [value]

### 2.2 Feature List
| ID | Feature | Priority | Acceptance Criteria |
|----|---------|----------|---------------------|
| F1 | [Feature name] | P0/P1/P2 | [Testable acceptance condition] |

### 2.3 Non-Functional Requirements
- Performance: [Specific metrics]
- Security: [Specific requirements]
- Availability: [Specific metrics]

## 3. Constraints & Assumptions
- Technical constraints: [List]
- Business constraints: [List]
- Critical assumptions: [List, with impact if assumption fails]

## 4. Risk Analysis
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk description] | High/Med/Low | High/Med/Low | [Specific measures] |

## 5. Glossary
| Term | Definition |
|------|------------|
| [Term] | [Explanation] |
```

#### 2.1.2 ARCHITECTURE.md (Architecture Design Document)

```markdown
# ARCHITECTURE: [Project Name]

## 1. Architecture Overview
### 1.1 Architectural Style
[Monolithic/Microservices/Event-driven/Layered/Hexagonal, etc.]

### 1.2 Technology Stack
| Layer | Technology | Rationale |
|-------|------------|-----------|
| Language | Java/Python/TS/Go | [Rationale] |
| Framework | [Name] | [Rationale] |
| Storage | [Database] | [Rationale] |
| Deployment | [Method] | [Rationale] |

## 2. System Architecture Diagram
```
[Use ASCII or Mermaid]
```

## 3. Component Design
### 3.1 Component Inventory
| Component | Responsibility | Dependencies |
|-----------|---------------|--------------|
| [Component name] | [Single responsibility description] | [Dependent components] |

### 3.2 Component Interactions
```
[Sequence diagram or flow chart]
```

## 4. Data Design
### 4.1 Data Model
```
[ER diagram or entity definitions]
```

### 4.2 Data Flow
[How data flows through the system]

## 5. Interface Design
### 5.1 Internal Interfaces
| Interface | Input | Output | Error Handling |
|-----------|-------|--------|----------------|
| [Interface name] | [Type] | [Type] | [Strategy] |

### 5.2 External Interfaces (if applicable)
| Interface | Protocol | Auth | Rate Limiting |
|-----------|----------|------|---------------|
| [API endpoint] | REST/gRPC | [Method] | [Strategy] |

## 6. Quality Attribute Design
### 6.1 Scalability
[Horizontal/vertical scaling approach]

### 6.2 Reliability
- Failure detection: [Mechanism]
- Failure recovery: [Mechanism]
- Degradation strategy: [Strategy]

### 6.3 Observability
- Logging: [Standards]
- Metrics: [Key metrics]
- Tracing: [Solution]

### 6.4 Security
- Authentication: [Solution]
- Authorization: [Solution]
- Data protection: [Solution]

## 7. Decision Records (ADR)
| Decision | Options | Choice | Rationale |
|----------|---------|--------|-----------|
| [Decision point] | [Option A/B] | [Choice] | [Trade-off analysis] |
```

#### 2.1.3 TEST_STRATEGY.md (Testing Strategy)

```markdown
# TEST STRATEGY: [Project Name]

## 1. Testing Layers
| Layer | Scope | Tools | Coverage Target |
|-------|-------|-------|-----------------|
| Unit Tests | Single function/class | [Framework] | ≥80% |
| Integration Tests | Component interactions | [Framework] | Critical paths |
| E2E Tests | Complete user flows | [Tools] | P0 scenarios |

## 2. Unit Testing Standards
- Every public function must have tests
- Naming: `Test[FunctionName]_[Scenario]_[ExpectedResult]`
- Must include: happy path, boundary conditions, error paths
- Mock external dependencies

## 3. Integration Testing Standards
- Test inter-component contracts
- Use test databases/containers
- Verify transaction behavior

## 4. Test Data
- Use factory pattern for test data
- Prohibit shared mutable test state
```

#### 2.1.4 PLAN.md (Project Plan) - NEW

```markdown
# PLAN: [Project Name]

## Task Overview
| Metric | Value |
|--------|-------|
| Total Tasks | [N] |
| Completed | [N] ([%]) |
| In Progress | [N] |
| Blocked | [N] |

## Task Breakdown (WBS)
| ID | Task | Status | Priority | Est. Hours | Dependencies | Deliverable |
|----|------|--------|----------|-----------|--------------|-------------|
| 1.1.1 | [Specific task] | ⬜/🔄/✅/🚫 | P0/P1/P2 | [Xh] | [Dep ID] | [Filename] |

## Dependency Graph
```
[Critical path visualization]
```

## Current Execution Status
### Current Task: [Task ID]
- Started: [YYYY-MM-DD HH:MM]
- Est. Complete: [YYYY-MM-DD HH:MM]
- Actual Hours: [Xh]

## Change Log
| Date | Change Type | Task ID | Change Description | Reason |
|------|-------------|---------|-------------------|--------|
```

**Core Purpose of PLAN.md**:
- **Externalized Task Board**: LLM reasoning persisted to file, not context-dependent
- **Context Recovery Checkpoint**: Resume here after interruptions
- **Trackable Progress**: Task status, hours, dependencies
- **Single Source of Truth**: All work must be tracked here

```markdown
# TEST STRATEGY: [Project Name]

## 1. Testing Layers
| Layer | Scope | Tools | Coverage Target |
|-------|-------|-------|-----------------|
| Unit Tests | Single function/class | [Framework] | ≥80% |
| Integration Tests | Component interactions | [Framework] | Critical paths |
| E2E Tests | Complete user flows | [Tools] | P0 scenarios |

## 2. Unit Testing Standards
- Every public function must have tests
- Naming: `Test[FunctionName]_[Scenario]_[ExpectedResult]`
- Must include: happy path, boundary conditions, error paths
- Mock external dependencies

## 3. Integration Testing Standards
- Test inter-component contracts
- Use test databases/containers
- Verify transaction behavior

## 4. Test Data
- Use factory pattern for test data
- Prohibit shared mutable test state
```

#### 2.1.4 PLAN.md (Project Plan) - NEW

See: `shared/templates/PLAN.md`

This document serves as:
- The single source of truth for all tasks
- An externalized, persistent task board
- A checkpoint for context recovery after interruptions
- A trackable progress reference

### 2.2 Design Confirmation Process

After producing design documents, you must:

```
Design documents completed:
- PRD-SPEC.md: Requirements specification
- ARCHITECTURE.md: Architecture design
- TEST_STRATEGY.md: Testing strategy
- PLAN.md: Project plan with task breakdown

Please review the above documents and confirm:
1. Is the requirements understanding correct?
2. Does the architecture design meet requirements?
3. Are there any omissions or adjustments needed?

Once confirmed, I will proceed to the implementation phase.
```

You may only proceed to Phase 3 after the user explicitly responds with "design confirmed, proceed with implementation."

---

## Phase 3: Implementation (IMPLEMENTATION)

### 3.1 Pre-Implementation Preparation

After design confirmation, first produce:

```markdown
# IMPLEMENTATION_PLAN.md

## Task Breakdown
| No. | Task | Dependencies | Est. Time | Deliverable |
|-----|------|--------------|-----------|-------------|
| 1 | [Specific task] | [Prerequisites] | [Estimate] | [Verifiable output] |

## Implementation Order
[Explain why this order]

## Verification Checklist
- [ ] Each task can be verified independently
- [ ] Integration points identified
```

### 3.2 Coding Standards

Follow language-specific standards (see below). Reference `shared/languages/{language}.md`.

### 3.3 Incremental Delivery

- After each feature point, proactively show code and request feedback
- Prohibit large code submissions at once
- If encountering uncovered design scenarios, pause and return to Phase 2

### 3.4 Validation Loop (Mandatory)

After each code change, execute validation:

```
Step 1: Compile/Type Check
   Command: tsc --noEmit / mypy . / go build / mvn compile
   Failure: Stop immediately, fix syntax errors

Step 2: Static Analysis
   Command: eslint . / ruff check . / golangci-lint run
   Failure: Fix all Errors, evaluate Warnings

Step 3: Unit Tests
   Command: jest / pytest / go test / mvn test
   Failure: Fix failing tests, add missing tests
   Target: Coverage ≥80%

Step 4: Code Review (Self-Review)
   Checklist:
   - [ ] Follows language standards
   - [ ] Clear naming
   - [ ] Appropriate comments
   - [ ] Proper error handling
   - [ ] No redundant code
```

### 3.5 PLAN.md Status Updates

Update task status in real-time during implementation:

```markdown
#### Task Detail: 1.1.1

**Implementation**: ✅ [2026-04-03 15:00]
**Validation**:
- Compile: ✅ [timestamp]
- Static Analysis: ✅ [timestamp]
- Unit Tests: 🔄 [Coverage: 75% → Target: 80%]
- Integration Tests: ⬜

**Validation History**:
- [2026-04-03 15:00] First validation: Compile failed, missing imports
- [2026-04-03 15:05] After fix: Compile passed, test coverage insufficient
```

---

## Language-Specific Standards

### Java
- Follow Google Java Style Guide
- Use `final` for immutable variables and parameters
- Prefer `Optional` over null
- Exception handling: checked exceptions for recoverable errors, runtime exceptions for programming errors
- Dependency injection: use Spring/Guice

### Python
- Follow PEP 8 + Google Python Style Guide
- Type annotations: all functions must have type hints
- Use dataclasses or Pydantic for data structures
- Exceptions: custom exceptions inherit from specific base classes
- Dependency management: use pyproject.toml + poetry/uv

### TypeScript
- Follow Google TypeScript Style Guide
- Strict mode: `strict: true`
- Prohibit `any`, use `unknown` + type guards
- Prefer `interface` for object shapes
- Error handling: use Result/Either pattern or explicit throws

### Go
- Follow Effective Go + Uber Go Style Guide
- Error handling: explicit checks, lowercase error messages
- Interfaces: small interfaces over large ones
- Concurrency: use context for cancellation signals
- Testing: table-driven tests, t.Parallel()

---

## General Code Standards

### Naming
- Variables/functions: clearly express intent, avoid abbreviations (unless industry standard)
- Classes/modules: nouns, single responsibility
- Booleans: use is/has/should/can prefixes

### Function Design
- Single responsibility: one function does one thing
- Parameter count: ≤3, use config objects/structs beyond that
- Return values: error as last return value (Go style) or use exceptions/Result
- Side effects: indicate in function name (e.g., `saveXxx`, `mutateXxx`)

### Comments
- Why > What > How
- Public APIs must have documentation comments
- Complex algorithms must explain principles

### Error Handling
- Error messages must include context (which operation, which entity)
- Distinguish user errors (4xx) from system errors (5xx)
- Logging: log at error origin, wrap when propagating

---

## Prohibited Actions

- ❌ Start writing code without requirements confirmation
- ❌ Enter implementation before design confirmation
- ❌ Submit >200 lines of changes at once (excluding tests)
- ❌ Use "TODO" or "FIXME" without creating tracking tasks
- ❌ Ignore compiler/static analysis warnings
- ❌ Submit untested code
- ❌ Hardcode configurations in code
- ❌ Proceed without updating PLAN.md status
- ❌ Skip validation steps before committing

---

## Communication Standards

- Communicate with user in Chinese (unless user requests English)
- At the end of each phase, explicitly ask "confirm proceeding to next phase?"
- When encountering uncertain issues, ask immediately rather than guess
- Progress reports: briefly report completion status after each milestone
- Always reference PLAN.md at session start to confirm current task

---

## Context Recovery

If a session is interrupted:

1. Read `PLAN.md` to understand current task status
2. Check last update timestamp for information freshness
3. Verify completed tasks by checking deliverables
4. Confirm current task with user
5. Ask: "According to PLAN.md, current task is [X]. Continue?"
