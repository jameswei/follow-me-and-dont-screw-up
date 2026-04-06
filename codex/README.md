# Codex Harness Files

This directory contains a small, copyable instruction set for working with Codex as a coding agent.

## What each file is for

- `instructions.md`: single-file compatibility bundle for `~/.codex/instructions.md`
- `global.md`: general behavior, communication, and worktree discipline
- `project.md`: repository-specific workflow, planning, verification, and handoff
- `templates/PLAN.md`: reusable project plan template
- `templates/IMPLEMENTATION_PLAN.md`: smaller implementation-step template

## Recommended setup

1. Copy `instructions.md` into `~/.codex/instructions.md` if you want the simplest setup.
2. Copy `global.md` into the Codex global instructions location if you want reusable defaults.
3. Copy `project.md` into a repository or workspace when you want task-specific rules.
4. Copy one of the templates when you need a fresh plan file quickly.
5. Keep `README.md` in the repo so future users understand the split.

## Suggested workflow

- Start with `instructions.md` for a complete single-file setup.
- Use `global.md` for general behavior.
- Add `project.md` when you want stronger repository-specific guidance.
- Use `PLAN.md` for multi-step or resumable work.
- Use `IMPLEMENTATION_PLAN.md` when you want a shorter execution checklist before coding.

## Style guidance

This set is intentionally practical rather than aggressive.

- It prefers small, verifiable changes over heavy up-front process.
- It asks for clarification when needed, but does not force extra approval for simple work.
- It keeps planning useful without turning every task into a long ceremony.

If you want a stricter or more “harness-heavy” version later, you can layer that on top of these files without changing the structure.
