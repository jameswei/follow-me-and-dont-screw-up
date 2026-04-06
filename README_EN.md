# Follow Me And Don't Screw Up

> Personal Coding Agent Engineering Standards & Best Practices Guide

[中文版本](./README.md) | **English Version**

---

## Introduction

This repository contains comprehensive engineering standards for guiding Claude Code, Codex, Cursor, and other AI Coding Agents. Our core principles:

- **Shared Neutral Core**: `instructions/core/` provides the common workflow and behavior baseline
- **Agent-Specific Wrappers**: `codex/`, `claude/`, and `cursor/` each generate their own instruction files
- **Documentation First**: All significant decisions must be documented
- **Measurable Standards**: Acceptance criteria, coverage, performance metrics
- **Language-Specific Standards**: Java, Python, TypeScript, Go

## What's New

- Split Codex instructions into `global.md`, `project.md`, and a compatibility bundle.
- Refactored the shared core to be agent-neutral instead of Codex-specific.
- Regenerated Claude and Cursor outputs so they now inherit the shared neutral baseline.
- Added `codex/README.md` plus reusable plan templates under `codex/templates/`.

## Repository Structure

```
follow-me-and-dont-screw-up/
├── README.md                    # Chinese version
├── README_EN.md                 # This file (English version)
├── codex/
│   ├── README.md                # Codex notes
│   ├── instructions.md          # Codex compatibility bundle
│   ├── global.md                # Codex global defaults
│   ├── project.md               # Codex project workflow
│   └── templates/
│       ├── PLAN.md              # Project plan template
│       └── IMPLEMENTATION_PLAN.md # Implementation plan template
├── cursor/
│   └── .cursorrules             # Cursor IDE rules file
├── shared/
│   ├── languages/
│   │   ├── java.md              # Java code standards
│   │   ├── python.md            # Python code standards
│   │   ├── typescript.md        # TypeScript code standards
│   │   └── go.md                # Go code standards
│   ├── templates/
│   │   └── PLAN.md              # Project plan template
│   ├── validation/
│   │   ├── validation-workflow.md  # Validation workflow
│   │   └── tool-recommendations.md # Recommended toolchain
│   ├── skills/
│   │   └── skill-recommendations.md # Recommended skills
│   └── setup/
│       ├── environment-setup.md    # Environment setup guide
│       ├── scripts/                # Environment setup scripts
│       │   ├── check-env.sh
│       │   ├── setup-python.sh
│       │   ├── setup-typescript.sh
│       │   ├── setup-java.sh
│       │   └── setup-go.sh
│       └── sandbox/                # Docker sandbox environments
│           ├── Dockerfile
│           ├── Dockerfile.python
│           ├── Dockerfile.typescript
│           ├── Dockerfile.java
│           ├── Dockerfile.go
│           ├── docker-compose.yml
│           ├── devcontainer.json
│           └── README.md
└── en/                          # English versions of all docs
    ├── codex/instructions.md
    ├── cursor/.cursorrules
    └── shared/
        ├── languages/
        ├── skills/
        ├── templates/
        ├── validation/
        └── setup/
```

## Quick Start

### 1. Installation

#### Codex (OpenAI)

```bash
# Single-file compatibility config
mkdir -p ~/.codex
cp codex/instructions.md ~/.codex/instructions.md

# Or in the project root
cp codex/instructions.md ./codex.md

# Or build the bundle yourself
cat codex/global.md codex/project.md > ~/.codex/instructions.md
```

#### Claude Code / Cursor

Their generated files are built from the shared neutral core in `instructions/core/`, with agent-specific wrappers applied on top.

#### Cursor

```bash
# Global configuration
cp cursor/.cursorrules ~/.cursorrules

# Or in project root
cp cursor/.cursorrules ./.cursorrules
```

### 2. New Project Startup Workflow

For projects that want stronger process control, you can use the phased template below. It is an example workflow, not a hard requirement of the shared core:

```
┌─────────────────────────────────────────────────────────────┐
│  Phase 1: Requirements Clarification                         │
│  - Output requirements understanding summary                 │
│  - Ask clarification questions                               │
│  - User confirms "requirements correct"                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Phase 2: Design Deliverables                                │
│  - docs/PRD-SPEC.md        (Requirements)                    │
│  - docs/ARCHITECTURE.md    (Architecture)                    │
│  - docs/TEST_STRATEGY.md   (Testing)                         │
│  - docs/PLAN.md            (Project Plan)                    │
│  - User confirms "design correct"                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Phase 3: Implementation                                     │
│  - docs/IMPLEMENTATION_PLAN.md (Iteration plan)              │
│  - Incremental delivery with checkpoints                     │
│  - Real-time PLAN.md status updates                          │
└─────────────────────────────────────────────────────────────┘
```

## Design Deliverables Templates

### PRD-SPEC.md

```markdown
# PRD-SPEC: [Project Name]

## 1. Overview
### 1.1 Background
### 1.2 Objectives
### 1.3 Success Criteria (Measurable)

## 2. Functional Requirements
### 2.1 User Stories
### 2.2 Feature List (ID | Feature | Priority | Acceptance Criteria)
### 2.3 Non-Functional Requirements

## 3. Constraints & Assumptions
## 4. Risk Analysis
## 5. Glossary
```

### ARCHITECTURE.md

```markdown
# ARCHITECTURE: [Project Name]

## 1. Architecture Overview
## 2. System Architecture Diagram
## 3. Component Design
## 4. Data Design
## 5. Interface Design
## 6. Quality Attribute Design (Scalability, Reliability, Observability, Security)
## 7. Decision Records (ADR)
```

### TEST_STRATEGY.md

```markdown
# TEST STRATEGY: [Project Name]

## 1. Testing Layers (Unit/Integration/E2E)
## 2. Unit Testing Standards
## 3. Integration Testing Standards
## 4. Test Data Management
```

### PLAN.md

```markdown
# PLAN: [Project Name]

## Task Overview
| Metric | Value |
|--------|-------|
| Total Tasks | N |
| Completed | N (%) |
| In Progress | N |
| Blocked | N |

## Task Breakdown (WBS)
| ID | Task | Status | Priority | Est. Hours | Dependencies | Deliverable |
|----|------|--------|----------|-----------|--------------|-------------|

## Dependency Graph
## Current Execution Status
## Change Log
```

**Purpose of PLAN.md:**
- **Externalized Task Board**: LLM reasoning and breakdown are persisted outside context
- **Context Recovery Checkpoint**: Reference point after interruptions
- **Trackable Progress**: Measurable task completion status
- **Single Source of Truth**: All work must be tracked here

## Language-Specific Standards

| Language | Primary Reference | Key Characteristics |
|----------|-------------------|---------------------|
| Java | Google Java Style + Effective Java | final, Optional, exception hierarchy |
| Python | PEP 8 + Google Python Style | Type annotations, dataclasses, Result pattern |
| TypeScript | Google TS Style | strict mode, no any, Result types |
| Go | Effective Go + Uber Style | Explicit errors, small interfaces, context |

See `shared/languages/` directory for complete standards.

## Validation & Toolchain

### Validation Workflow

After code implementation, must pass validation loop:

```
Compile Check → Static Analysis → Unit Tests → Integration Tests → Code Review
```

See `shared/validation/validation-workflow.md`

### Recommended Toolchain

Recommended validation tools by language:

| Language | Type Check | Format | Lint | Test | Security |
|----------|------------|--------|------|------|----------|
| TypeScript | `tsc` | `Prettier` | `ESLint` | `Jest` | `npm audit` |
| Python | `mypy` | `Black` | `ruff` | `pytest` | `bandit` |
| Go | `go build` | `gofmt` | `golangci-lint` | `go test` | `gosec` |
| Java | `javac` | `google-java-format` | `Checkstyle` | `JUnit` | `OWASP DC` |

See `shared/validation/tool-recommendations.md`

## Skills & Extensions

### Core Skills

| Skill | Purpose | Trigger Condition |
|-------|---------|-------------------|
| Code Review | Systematic code issue detection | Every >50 line change |
| Refactoring | Identify smells, provide solutions | Code smell detected |
| Test Generation | Auto-generate test cases | Coverage <80% |
| Doc Generation | Auto-generate API docs | Public API changes |

See `shared/skills/skill-recommendations.md`

## Environment Setup

### Environment Check & Initialization

Before starting a project, environment check must be completed:

```bash
# 1. Run environment check
./scripts/check-env.sh

# 2. Initialize environment based on project type
./scripts/setup-python.sh      # Python (uv)
./scripts/setup-typescript.sh  # TypeScript (nvm + npm/bun)
./scripts/setup-java.sh        # Java (jenv + maven)
./scripts/setup-go.sh          # Go (goenv)
```

### Recommended Version Managers

| Language | Version Manager | Package Manager | Characteristics |
|----------|-----------------|-----------------|-----------------|
| Python | `uv` | `uv pip` | Fast, modern |
| TypeScript | `nvm` | `npm`/`bun` | Flexible, rich ecosystem |
| Java | `jenv` | `maven` | Multi-JDK management |
| Go | `goenv` | `go mod` | Simple, efficient |

See `shared/setup/environment-setup.md`

### Docker Sandbox Environment

Provides isolated, reproducible development environments:

```bash
# Start language-specific sandbox
docker-compose -f sandbox/docker-compose.yml up -d python-dev
docker-compose -f sandbox/docker-compose.yml up -d typescript-dev

# Or start universal multi-language sandbox
docker-compose -f sandbox/docker-compose.yml up -d dev

# Enter sandbox
docker-compose -f sandbox/docker-compose.yml exec dev bash
```

**Sandbox Types**:
- Single-language Dockerfile (lightweight)
- Universal multi-language Dockerfile (all-in-one)
- Docker Compose (multi-service orchestration)
- Dev Container (VS Code integration)

See `shared/setup/sandbox/README.md`

## Key Principles

### 1. Prohibited Actions

- ❌ Start writing code without requirements confirmation
- ❌ Enter implementation before design confirmation
- ❌ Submit >200 lines of changes at once (excluding tests)
- ❌ Use "TODO" or "FIXME" without creating tracking tasks
- ❌ Ignore compiler/static analysis warnings
- ❌ Submit untested code
- ❌ Hardcode configurations in code
- ❌ Proceed without updating PLAN.md status
- ❌ Skip validation steps before committing

### 2. Mandatory Actions

- ✅ Ask "confirm proceeding to next phase?" at end of each phase
- ✅ Use markdown format for all design documents
- ✅ Acceptance criteria must be measurable and testable
- ✅ Public APIs must have documentation comments
- ✅ Error messages must include context
- ✅ Use version control, commit in small steps
- ✅ Update PLAN.md status in real-time during implementation

### 3. Communication Standards

- Communicate with user in Chinese (unless user requests English)
- At the end of each phase, explicitly ask "confirm proceeding to next phase?"
- When encountering uncertain issues, ask immediately rather than guess
- Progress reports: briefly report completion status after each milestone
- Always reference PLAN.md at session start to confirm current task

## Context Recovery with PLAN.md

If a session is interrupted:

1. **Read PLAN.md**: Understand current task status
2. **Check last update**: Confirm information freshness
3. **Verify completed tasks**: Quickly check if deliverables exist
4. **Confirm current task**: Clarify what to do next
5. **Ask user**: "According to PLAN.md, current task is [X]. Continue?"

## Customization & Extension

### Adding New Language Standards

1. Create `{language}.md` in `shared/languages/`
2. Follow existing standard structure
3. Update language table in this README

### Adjusting Strictness

Edit the corresponding agent configuration file:

- **Stricter**: Add checks, lower coverage thresholds
- **Looser**: Remove non-core checks, raise thresholds

### Project-Specific Overrides

Create `.coding-standards.md` in project root:

```markdown
# Project-Specific Overrides

## Override Global Standards
- Line length limit: 120 characters (instead of 100)
- Unit test coverage: 70% (instead of 80%)

## Project-Specific Rules
- Must use PostgreSQL
- No ORM, use raw SQL
```

## Version Control

```bash
# Initialize repository
git init
git add .
git commit -m "Initial commit: coding standards v1.0"

# Push to private repository
git remote add origin <your-private-repo>
git push -u origin main
```

## Changelog

### v1.1 (2026-04-03)
- Added PLAN.md template for externalized task tracking
- Added English versions of all documents
- Enhanced context recovery procedures
- Added environment setup scripts and Docker sandbox

### v1.0 (2026-04-03)
- Initial release
- Support for Codex, Cursor configuration
- Include Java, Python, TypeScript, Go standards
- Three-phase workflow definition

## References

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [PEP 8](https://peps.python.org/pep-0008/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
- [Effective Go](https://go.dev/doc/effective_go)
- [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)

---

**Remember**: These standards are tools, not dogma. Adjust based on project reality, but core principles (documentation first, three-phase confirmation) should not be compromised.
