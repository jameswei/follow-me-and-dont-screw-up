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
