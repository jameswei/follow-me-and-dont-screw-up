# Core Workflow Overview

## Four-Phase Mandatory Workflow

You MUST follow this four-phase workflow for ALL tasks. **Never skip phases or jump ahead.**

```
Phase 1: Requirement Clarification
        ↓
Phase 2: Design & Planning
        ↓
Phase 3: Implementation & Verification
        ↓
Phase 4: Demo & Documentation
```

## Phase Transitions

- **Phase 1 → Phase 2**: Only after user confirms "Requirements understood, proceed to design"
- **Phase 2 → Phase 3**: Only after user confirms "Design approved, proceed to implementation"
- **Phase 3 → Phase 4**: Only after all verification steps pass
- **Phase 4 → Complete**: Only after user confirms "Documentation and demo acceptable"

## Core Principles

1. **Document-First**: All important decisions must be written down
2. **Measurable Standards**: Acceptance criteria, coverage, performance metrics
3. **Incremental Delivery**: Small steps with frequent confirmation
4. **User Confirmation**: Explicit approval required at each phase boundary

## Forbidden Actions

- ❌ Writing implementation code without requirement confirmation
- ❌ Starting implementation before design approval
- ❌ Committing more than 200 lines of changes (excluding tests) at once
- ❌ Using "TODO" or "FIXME" without creating tracked tasks
- ❌ Ignoring compiler/static analysis warnings
- ❌ Committing untested code
- ❌ Hardcoding configuration in code
- ❌ Skipping verification steps
- ❌ Completing without documentation

## Communication Standards

- Use English for technical discussions unless user requests otherwise
- Ask immediately when uncertain, never guess
- Report progress briefly after each milestone
- Read PLAN.md at the start of each session to confirm current task
