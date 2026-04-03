# Project Plan (PLAN)
# Location: docs/PLAN.md
# Purpose: Task decomposition, dependency management, status tracking
# Core Principle: This file is the single source of truth for all tasks.
#                  All work must be tracked here.

# =============================================================================
# Project Information
# =============================================================================

Project Name: [PROJECT_NAME]
Version: [VERSION]
Created: [DATE]
Last Updated: [DATE]

# =============================================================================
# Task Overview
# =============================================================================

## Key Metrics

| Metric | Value |
|--------|-------|
| Total Tasks | [N] |
| Completed | [N] ([%]) |
| In Progress | [N] |
| Blocked | [N] |
| Estimated Total Duration | [X days/weeks] |

## Task Status Legend

- `⬜` Not Started - Task has not begun
- `🔄` In Progress - Task is actively being worked on
- `✅` Done - Task is complete and verified
- `🚫` Blocked - Task cannot proceed (requires reason and unblock criteria)
- `⏸️` Paused - Task is temporarily suspended (requires reason)

# =============================================================================
# Task Breakdown (WBS)
# =============================================================================

## Phase 1: [Phase Name]

**Objective**: [One-sentence description of this phase's goal]
**Acceptance Criteria**: [Measurable completion criteria]
**Estimated Duration**: [X days]

### 1.1 [Task Group Name]

| ID | Task | Status | Priority | Owner | Est. Hours | Actual Hours | Dependencies | Deliverable |
|----|------|--------|----------|-------|-----------|-------------|--------------|-------------|
| 1.1.1 | [Specific task description] | ⬜ | P0 | Agent | 4h | - | - | [Filename] |
| 1.1.2 | [Specific task description] | ⬜ | P0 | Agent | 2h | - | 1.1.1 | [Filename] |
| 1.1.3 | [Specific task description] | ⬜ | P1 | Agent | 3h | - | 1.1.1 | [Filename] |

#### Task Detail: 1.1.1

**Description**: [Detailed description of task content]

**Implementation Approach**: [Key implementation steps or technical approach]

**Acceptance Criteria**:
- [ ] Criterion 1: [Specific verifiable condition]
- [ ] Criterion 2: [Specific verifiable condition]

**Potential Risks**:
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk description] | High/Med/Low | High/Med/Low | [Specific measures] |

**Notes/Update Log**:
- [YYYY-MM-DD HH:MM] [Update content]

---

### 1.2 [Task Group Name]

[Same structure as above]

## Phase 2: [Phase Name]

[Same structure as above]

# =============================================================================
# Dependency Graph
# =============================================================================

## Task Dependency Matrix

```
        1.1.1   1.1.2   1.1.3   1.2.1   1.2.2   2.1.1
1.1.1     -       →       →       →       -       -
1.1.2     -       -       -       →       →       -
1.1.3     -       -       -       -       →       -
1.2.1     -       -       -       -       →       →
1.2.2     -       -       -       -       -       →
2.1.1     -       -       -       -       -       -

→ indicates row task blocks column task
  (column cannot start until row is complete)
```

## Critical Path

```
[1.1.1] → [1.1.2] → [1.2.1] → [1.2.2] → [2.1.1] → [Complete]
   ↓
[1.1.3] (can run in parallel with 1.1.2)
```

**Critical Path Total Duration**: [X days] (any delay here delays project completion)

# =============================================================================
# Priority Rules
# =============================================================================

## P0 - Blocking (Must complete first)

- Tasks that block all other work
- Core architecture setup
- Critical interface definitions

## P1 - Core Functionality (Must complete before MVP)

- Core business process implementation
- Primary user scenario coverage
- Key quality attribute implementation

## P2 - Important Functionality (Can iterate after MVP)

- Secondary features
- Performance optimizations
- Scalability improvements

## P3 - Value-Add Features (Can defer or descope)

- Nice-to-have features
- Advanced capabilities
- Polish and refinement

# =============================================================================
# Current Execution Status
# =============================================================================

## Current Iteration: [Iteration Number]

**Iteration Goal**: [One-sentence description]
**Timebox**: [Start Date] - [End Date]
**Current Date**: [DATE]

### This Iteration's Tasks

| ID | Task | Status | Progress | Est. Remaining | Risk |
|----|------|--------|----------|----------------|------|
| | | | | | |

### Iteration Burndown (Text Version)

```
Remaining Tasks
   │
10 ┤████
 9 ┤████
 8 ┤███████
 7 ┤█████████
 6 ┤████████████
 5 ┤███████████████
 4 ┤██████████████████
 3 ┤█████████████████████
 2 ┤█████████████████████████
 1 ┤████████████████████████████
 0 ┤████████████████████████████████
   └───────────────────────────────────
     D1  D2  D3  D4  D5  D6  D7  D8  D9  D10
```

## Blocked Items

| ID | Task | Block Reason | Unblock Criteria | Est. Unblock Time |
|----|------|--------------|------------------|-------------------|
| | | | | |

## Change Log

| Date | Change Type | Task ID | Change Description | Reason |
|------|-------------|---------|-------------------|--------|
| | Add/Modify/Delete/Reorder | | | |

# =============================================================================
# Context Recovery Guide
# =============================================================================

## If Session Is Interrupted, Resume From Here

1. **Read this file**: Understand current task status
2. **Check last update**: Confirm information freshness
3. **Verify completed tasks**: Quickly check if deliverables exist
4. **Confirm current task**: Clarify what to do next
5. **Ask user**: "According to PLAN.md, current task is [X]. Continue?"

## Session Recovery Checklist

- [ ] Read PLAN.md
- [ ] Confirmed current task status
- [ ] Checked if dependency tasks are complete
- [ ] Verified environment/code state
- [ ] Confirmed direction with user

# =============================================================================
# Usage Guide
# =============================================================================

## For Agent

1. **At start of each session**: Read this file, confirm current task
2. **Before starting a task**: Update status to `🔄`, record start time
3. **After completing a task**: Update status to `✅`, record actual hours, check off acceptance criteria
4. **When blocked**: Update status to `🚫`, record reason and unblock criteria
5. **When plan changes**: Record in "Change Log" with reason

## For User

1. **Review plan**: Confirm task breakdown is reasonable, dependencies are correct
2. **Adjust priorities**: Adjust P0/P1/P2/P3 based on business needs
3. **Track progress**: Understand project status through this file
4. **Approve changes**: Major changes require user confirmation

# =============================================================================
# Template Usage Example
# =============================================================================

## Example: User Registration Feature

### Phase 1: Foundation

| ID | Task | Status | Priority | Est. Hours | Dependencies | Deliverable |
|----|------|--------|----------|-----------|--------------|-------------|
| 1.1.1 | Design user data model | ✅ | P0 | 2h | - | `docs/models/user.md` |
| 1.1.2 | Create database migration script | 🔄 | P0 | 1h | 1.1.1 | `migrations/001_create_users.sql` |
| 1.1.3 | Implement user Repository | ⬜ | P0 | 3h | 1.1.2 | `src/repository/user.ts` |

#### Task Detail: 1.1.2

**Description**: Create database migration script for user table with basic fields

**Implementation Approach**:
1. Use [migration tool name]
2. Fields: id, email, password_hash, created_at, updated_at
3. Add index: email (unique)

**Acceptance Criteria**:
- [ ] Migration script executes successfully
- [ ] Rollback script executes successfully
- [ ] Field types and constraints are correct

**Notes/Update Log**:
- [2026-04-03 14:00] Started task, chose Prisma Migrate
- [2026-04-03 14:30] Completed script, awaiting user confirmation
