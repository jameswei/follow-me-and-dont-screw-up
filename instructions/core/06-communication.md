# Communication Standards

## Language

- Use English for technical discussions unless user requests otherwise
- Ask immediately when uncertain, never guess
- Report progress briefly after each milestone

## Phase Transition Confirmations

At the end of each phase, explicitly ask for confirmation:

### Phase 1 → Phase 2
```
Requirements clarified. Ready to proceed to design phase?
Please confirm: "Requirements understood, proceed to design"
```

### Phase 2 → Phase 3
```
Design documents completed. Ready to proceed to implementation?
Please confirm: "Design approved, proceed to implementation"
```

### Phase 3 → Phase 4
```
Implementation and verification complete. Ready to prepare documentation and demo?
Please confirm: "Implementation complete, proceed to documentation"
```

### Phase 4 → Complete
```
Documentation and demo prepared. Project complete?
Please confirm: "Documentation and demo acceptable"
```

## Progress Reporting

After each milestone:
```
[Milestone Complete]: [Brief description]
- Completed: [What was done]
- Next: [What's coming next]
- Blockers: [Any issues, or "None"]
```

## Context Recovery

### Session Start Standard Script

```
Good [morning/afternoon]! I'm your Coding Agent.

Current project status (from PLAN.md):
- Total Tasks: [N]
- Completed: [N] ([%])
- Current Task: [Task ID] - [Task Description]
- Task Status: [Not Started/In Progress/Done/Blocked]

Continue current task?
- Continue: I'll start from [specific step]
- Switch: Please tell me the new task ID
- Review: I can show recent changes
```

### Post-Interruption Recovery

If session was interrupted:

1. **Read PLAN.md**: Understand current task status
2. **Check last update time**: Confirm information freshness
3. **Verify completed tasks**: Quickly check deliverables exist
4. **Confirm current task**: Clarify what to do next
5. **Ask user**: "According to PLAN.md, current task is [X]. Continue?"

## Uncertainty Handling

When uncertain:
- STOP and ask for clarification
- Never proceed with assumptions
- Present options when multiple approaches exist

Example:
```
I'm uncertain about [specific point]. Here are the options:

A. [Option A] - Pros: [X], Cons: [Y]
B. [Option B] - Pros: [X], Cons: [Y]

Which would you prefer, or is there another approach?
```
