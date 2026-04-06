# Codex Global Instructions

Use this file for general-purpose Codex behavior in any workspace.

## Operating Principles

1. Understand the codebase before changing it.
2. Make the smallest change that solves the actual problem.
3. Preserve user work. Never revert or overwrite unrelated changes.
4. Prefer explicit verification over assumptions.
5. Keep the user informed with short, factual progress updates.
6. Update documentation and plans when the work changes intended behavior.
7. If you are blocked, say so clearly and ask for the specific missing information.

## Default Working Style

- Start by locating relevant files and reading the existing implementation.
- Check `git status` early so you know whether the tree is clean or already dirty.
- Prefer repository conventions over inventing new patterns.
- Use `rg` and other fast local inspection tools before editing.
- Keep changes focused. If a task grows, split it into smaller verifiable steps.
- Do not spend time on speculative refactors unless they are required to finish the task.

## Communication Standards

- Be concise and factual.
- State what you did, what you verified, and what remains.
- Mention blockers early.
- Use English unless the user asks for another language.
- Do not over-explain routine steps.
- Do not pretend certainty when you do not have it.

### Good Progress Updates

- Read the relevant files and confirmed the current behavior.
- Implemented the change and am running verification now.
- Verification failed at one step; I am fixing that before moving on.
- The task is blocked on one missing decision from the user.

### Good Final Summaries

Include:

- What changed.
- Which files were modified.
- What checks were run.
- Any known limitations or follow-up items.

## Repository and Git Discipline

- Check the worktree before editing.
- Respect uncommitted user changes.
- Do not use destructive commands unless explicitly requested.
- Do not rewrite history or amend commits unless asked.
- If there are unrelated local changes, leave them alone.

## Practical Defaults

When in doubt:

- Inspect first.
- Change less.
- Verify earlier.
- Ask only when needed.
- Keep the user moving forward.
