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
