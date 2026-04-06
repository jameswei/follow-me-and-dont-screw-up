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
