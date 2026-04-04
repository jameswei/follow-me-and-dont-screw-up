# Phase 2: Design & Planning

## Design Deliverables

After user confirms requirements, you MUST produce the following documents in `docs/` directory:

### 2.1 PRD-SPEC.md (Product Requirements Document)

```markdown
# PRD-SPEC: [Project Name]

## 1. Overview
### 1.1 Background
[Why this feature is needed]

### 1.2 Goal
[One sentence goal]

### 1.3 Success Criteria (Measurable)
- [ ] Criterion 1: [Specific metric]
- [ ] Criterion 2: [Specific metric]

## 2. Functional Requirements
### 2.1 User Stories
As a [role], I want [feature], so that [value]

### 2.2 Feature List
| ID | Feature | Priority | Acceptance Criteria |
|----|---------|----------|---------------------|
| F1 | [Name] | P0/P1/P2 | [Testable conditions] |

### 2.3 Non-Functional Requirements
- Performance: [Specific metrics]
- Security: [Specific requirements]
- Availability: [Specific metrics]

## 3. Constraints & Assumptions
- Technical constraints: [List]
- Business constraints: [List]
- Key assumptions: [List with impact if wrong]

## 4. Risk Analysis
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Description] | High/Med/Low | High/Med/Low | [Specific actions] |

## 5. Glossary
| Term | Definition |
|------|------------|
| [Term] | [Explanation] |
```

### 2.2 ARCHITECTURE.md (Architecture Design)

```markdown
# ARCHITECTURE: [Project Name]

## 1. Architecture Overview
### 1.1 Architecture Style
[Monolithic/Microservices/Event-driven/Layered/Hexagonal]

### 1.2 Tech Stack
| Layer | Technology | Rationale |
|-------|------------|-----------|
| Language | Java/Python/TS/Go | [Reason] |
| Framework | [Name] | [Reason] |
| Storage | [Database] | [Reason] |
| Deployment | [Method] | [Reason] |

## 2. System Architecture Diagram
[Use Mermaid or ASCII]

## 3. Component Design
### 3.1 Component List
| Component | Responsibility | Dependencies |
|-----------|---------------|--------------|
| [Name] | [Single responsibility] | [Dependencies] |

### 3.2 Component Interactions
[Sequence diagram or flow]

## 4. Data Design
### 4.1 Data Model
[ER diagram or entity definitions]

### 4.2 Data Flow
[How data flows through the system]

## 5. Interface Design
### 5.1 Internal Interfaces
| Interface | Input | Output | Error Handling |
|-----------|-------|--------|----------------|
| [Name] | [Type] | [Type] | [Strategy] |

### 5.2 External Interfaces (if applicable)
| Interface | Protocol | Auth | Rate Limit |
|-----------|----------|------|------------|
| [API endpoint] | REST/gRPC | [Method] | [Strategy] |

## 6. Quality Attributes
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

### 2.3 TEST_STRATEGY.md (Test Strategy)

```markdown
# TEST STRATEGY: [Project Name]

## 1. Test Layers
| Layer | Scope | Tools | Coverage Target |
|-------|-------|-------|-----------------|
| Unit | Single function/class | [Framework] | ≥80% |
| Integration | Component interactions | [Framework] | Critical paths |
| E2E | Complete user flows | [Tools] | P0 scenarios |

## 2. Unit Test Standards
- Every public function must have tests
- Naming: `Test[FunctionName]_[Scenario]_[ExpectedResult]`
- Must include: happy path, boundary conditions, error paths
- Mock external dependencies

## 3. Integration Test Standards
- Test component contracts
- Use test databases/containers
- Verify transaction behavior

## 4. Test Data
- Use factory pattern for test data
- No shared mutable test state
```

### 2.4 PLAN.md (Project Plan)

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
|----|------|--------|----------|------------|--------------|-------------|
| 1.1.1 | [Task] | ⬜/🔄/✅/🚫 | P0/P1/P2 | [Xh] | [Dep ID] | [Filename] |

## Dependency Graph
[Critical path visualization]

## Current Status
### Current Task: [Task ID]
- Start Time: [YYYY-MM-DD HH:MM]
- Est. Completion: [YYYY-MM-DD HH:MM]
- Actual Hours: [Xh]

## Change Log
| Date | Change Type | Task ID | Change | Reason |
|------|-------------|---------|--------|--------|
```

**PLAN.md Core Purpose**:
- **External Task Board**: LLM reasoning persisted to file, not context-dependent
- **Context Recovery Checkpoint**: Resume here after interruption
- **Trackable Progress**: Task status, hours, dependencies
- **Single Source of Truth**: All work must be tracked here

## Phase 2 Completion Criteria

After producing design documents, you MUST say:

```
Design documents completed in docs/ directory:
- PRD-SPEC.md: Requirements specification
- ARCHITECTURE.md: Architecture design
- TEST_STRATEGY.md: Test strategy
- PLAN.md: Project plan

Please review and confirm:
1. Is the requirement understanding correct?
2. Does the architecture meet requirements?
3. Are there any omissions or adjustments needed?

After your confirmation, I will proceed to implementation.
```

Only proceed to Phase 3 after user explicitly confirms "Design approved, can start implementation".
