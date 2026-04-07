# CLAUDE.md
# Location: Project root CLAUDE.md
# Purpose: Claude Code system instructions

# Shared Workflow Overview

## Operating Style

Use a lightweight, risk-aware workflow.

1. Read the relevant files and understand the request in context.
2. Decide whether the task is simple enough to start directly or complex enough to benefit from a brief plan.
3. Make the smallest change that solves the actual problem.
4. Verify the change with the narrowest useful checks.
5. Summarize what changed, what was verified, and any remaining risk.

## Default Principles

- Optimize for correctness, clarity, and momentum.
- Prefer repository conventions over inventing new patterns.
- Preserve user work and avoid unrelated changes.
- Ask for clarification only when the cost of a wrong assumption is meaningful.
- Keep documentation and tracking artifacts current when the work changes behavior or scope.

## Good Decision Rules

- If the request is small and clear, start immediately.
- If the request has multiple plausible approaches, surface the tradeoff before coding.
- If the task is large or interruptible, keep notes in `PLAN.md`.
- If a check fails, fix the failure before moving on.

## Communication Baseline

- Be concise and factual.
- Use English unless the user requests another language.
- Report blockers early.
- State what you did, what you verified, and what remains.
- Do not pretend certainty when you do not have it.

# Request Understanding

Before changing code or docs, build a clear understanding of the request.

## What to Confirm

- What problem is being solved.
- What is in scope and what is explicitly out of scope.
- Any constraints that affect implementation, compatibility, or verification.
- Whether the task is purely documentation, a behavior change, or both.

## When to Ask Questions

Ask only when the answer changes the implementation path or the risk of a wrong assumption is high.

Useful questions are usually about:

- User intent
- Expected behavior
- Existing conventions to follow
- Required compatibility or environment constraints

If the intent is already clear from the repository and the request, proceed without extra ceremony.

## Practical Output

When clarification is needed, provide:

- A short summary of your understanding
- The specific unknowns
- The decision points that matter

Avoid long questionnaires. Keep the user moving.

# Planning and Design

Use planning when it reduces risk or helps the task stay reviewable.

## Planning Signals

Create or update `PLAN.md` when the work is:

- Multi-step
- Interruptible
- Dependent on another task
- Likely to span more than one session

## Useful Planning Contents

- Short task summary
- Subtasks or milestones
- Dependencies and blockers
- Current status
- Verification notes

## Design Guidance

- Prefer the smallest design that cleanly solves the problem.
- Keep the plan aligned with the current implementation, not the original guess.
- If design choices affect user-facing behavior, note the tradeoffs.
- If a separate implementation plan helps, create one, but keep it short.

## Good Plan Hygiene

- Mark progress as it happens.
- Keep task names specific.
- Record blockers instead of hiding them in chat.
- Update the plan when scope changes.

# Implementation and Verification

Implement in small steps and verify as you go.

## Implementation Guidelines

- Make direct, local edits before considering broad refactors.
- Match the existing architecture unless there is a clear reason to change it.
- Avoid mixing unrelated cleanup into the requested task.
- Keep public behavior stable unless the request explicitly changes it.

## Verification Order

Prefer the narrowest checks that prove the change works:

1. Syntax or type checks
2. Lint or static analysis
3. Targeted tests for the changed area
4. Broader tests if the risk justifies it

## Quality Expectations

- Use clear names.
- Keep functions focused.
- Handle errors with enough context to debug them.
- Add tests when behavior changes or when regressions are likely.

## When to Pause

Pause when:

- A missing decision blocks the implementation path.
- A test or check fails in a way that changes the planned approach.
- The requested change is broader than it first appeared.

## Practical Handoff

Before finishing, make sure the change matches the request, the relevant checks ran or were explained, and the workspace does not contain accidental edits.

# Documentation and Demonstration

Documentation should reflect the implementation, not an imagined end state.

## When to Update Docs

Update docs when the change affects:

- User-facing behavior
- Setup or environment requirements
- Commands or workflows
- Architecture or design assumptions

## Keep Documentation Practical

- Prefer concise, accurate docs over long prose.
- Use the repository’s existing doc structure when possible.
- Include examples only when they are useful and current.

## Demonstration Guidance

For non-trivial changes, include evidence that the work is usable:

- UI: screenshots or a short recording
- API: request/response examples
- CLI: example commands and outputs

## Final Check

Before handoff, verify that the documentation matches the implemented behavior and that any examples still work.

# Communication

Keep communication short, factual, and useful.

## Baseline

- State what you are doing.
- State what you verified.
- State what remains.
- Mention blockers early.
- Use English unless the user asks otherwise.

## Good Updates

- I read the relevant files and confirmed the current behavior.
- I implemented the change and am verifying it now.
- I found an issue and am fixing it before moving on.
- The task is blocked on one missing decision.

## When Uncertain

If there are multiple viable paths, summarize the options briefly and call out the tradeoff that matters.

Avoid over-explaining routine steps or pretending certainty when you do not have it.

# Claude Code — Agent-Specific Guidelines

These guidelines apply only to Claude Code and supplement the shared workflow above.

## Tool Use Preferences

Claude Code has dedicated tools that are safer and more reviewable than raw shell commands.
Prefer them in this order:

| Task | Preferred tool | Avoid |
|---|---|---|
| Read a file | `Read` | `cat`, `head`, `tail` via Bash |
| Edit a file | `Edit` | `sed`, `awk` via Bash |
| Create a file | `Write` | `echo >` or heredoc via Bash |
| Find files | `Glob` | `find`, `ls` via Bash |
| Search content | `Grep` | `grep`, `rg` via Bash |
| Broad exploration | `Agent (Explore)` | open-ended Bash loops |
| System commands | `Bash` | — (appropriate here) |

Use `Bash` only when a dedicated tool cannot accomplish the task (e.g., running tests, installing packages, calling CLI tools).

## In-Session Task Tracking

For work that happens within a single conversation, prefer native task tools over a static file:

- Use `TaskCreate` to break multi-step work into discrete tasks.
- Use `TaskUpdate` to mark tasks `in_progress` when starting and `completed` when done.
- Use `PLAN.md` when work spans multiple sessions or needs to persist after the conversation ends.

## Destructive Operation Protocol

Before any action that is hard or impossible to reverse, state the action and confirm with the user:

- Deleting files or directories
- `git reset --hard`, `git checkout -- .`, `git clean -f`
- Force-pushing any branch
- Dropping database tables or truncating data
- Overwriting uncommitted changes
- Modifying CI/CD pipelines or shared infrastructure

A single user approval covers only the specific action requested, not a class of similar actions.

## Git Workflow

- Create new commits; do not amend unless the user explicitly asks.
- Stage specific files by name — avoid `git add -A` or `git add .`.
- Never force-push `main` or `master`. Warn the user if they request it.
- Never skip hooks (`--no-verify`) unless the user explicitly asks.
- If a pre-commit hook fails, fix the root cause and create a new commit — do not amend the previous one.
- Write commit messages that explain *why*, not just *what*.
