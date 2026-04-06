# Codex Project Instructions

Use this file for repository-specific work: planning, implementation, verification, and handoff.

## Session Workflow

1. Inspect the relevant files and understand the current behavior.
2. Identify the goal, constraints, and any missing information.
3. Decide whether a brief plan is needed.
4. Implement the change in small, reviewable increments.
5. Verify the result with the most relevant checks.
6. Summarize what changed, what was verified, and any remaining risk.

### When to Pause for Clarification

Pause and ask the user only when one of these is true:

- The request is ambiguous enough that a wrong interpretation would be costly.
- There are two or more materially different approaches and the choice matters.
- The task depends on information that is not available locally.
- The change is high risk, broad, or likely to affect external behavior significantly.

If the task is straightforward and the intent is clear, proceed without forcing extra confirmation.

## Planning and Tracking

### When to Create or Update `PLAN.md`

Use `PLAN.md` when the task is multi-step, long-running, or likely to be resumed later. For small one-off fixes, a full plan file is optional.

If `PLAN.md` exists:

- Read it at the start of the session.
- Keep it current as work progresses.
- Treat it as the source of truth for progress, dependencies, and verification status.

### What a Useful Plan Contains

- A short task summary.
- Clear milestones or subtasks.
- Dependencies and blockers.
- Status for each task.
- Verification steps and results.
- Notes that help resume work after interruption.

### Good Plan Hygiene

- Keep task names specific.
- Mark completed work immediately.
- Record blockers instead of silently waiting.
- Update the plan when the scope changes.
- Do not let the plan become a duplicate of chat history.

## Implementation Rules

- Prefer direct, local edits over broad refactors.
- Keep commits or change sets small enough to review comfortably.
- Match the existing architecture unless there is a strong reason to change it.
- Favor clarity over cleverness.
- Avoid adding new abstractions unless they reduce real complexity.
- Keep public behavior stable unless the task explicitly requests a change.
- If you discover a separate bug while working, note it and decide with the user whether to fix it now or later.

### Code Quality Expectations

- Names should be clear and intention-revealing.
- Functions should do one thing.
- Prefer simple control flow.
- Handle errors explicitly and include enough context to debug them.
- Remove dead code only when it is clearly obsolete.
- Add comments only when they explain why something is done, not what the code already says.

### Change Size

- Keep changes as small as practical.
- If a change becomes large, split it into logical steps and verify each step.
- Avoid mixing unrelated refactors with the requested work.

## Verification

Verify the change with the narrowest checks that prove it works, then broaden if needed.

Typical verification order:

1. Syntax or type checks.
2. Lint or static analysis.
3. Targeted tests for the changed area.
4. Broader test suite if the risk justifies it.

Guidelines:

- Fix failures before moving on.
- Add tests when behavior changes or when the bug would otherwise recur.
- Do not claim success without running the relevant checks.
- If a check cannot be run, explain why and what risk remains.

### Before Handoff

Before finishing, make sure:

- The change matches the request.
- The relevant checks passed or the user was told why they could not be run.
- The plan file is current, if one is being used.
- No unrelated files were modified.

## Documentation

Update documentation when the change affects:

- User-facing behavior.
- Setup or environment requirements.
- Commands or workflows.
- Architecture or design assumptions.

Prefer concise, accurate docs over long prose. If the repo has an established docs structure, use it.
