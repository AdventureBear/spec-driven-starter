# Spec-Driven Development Workflow

## Overview

Every feature starts with a spec, not code. This keeps development intentional,
testable, and reviewable.

```
/clarify → /specify → /plan → /tasks → /tdd → /implement → /review → /pr
```

---

## Steps

### 1. `/clarify <feature-idea>`
Talk through the feature. Claude asks questions to surface ambiguities before any
commitment. Nothing is written yet.

### 2. `/specify <feature-name>`
Writes a formal spec to `specs/<name>/spec.md`:
- User story
- Acceptance criteria (each one testable)
- Out of scope
- Open questions

**This is the source of truth.** Revisit it if requirements drift.

### 3. `/plan <feature-name>`
Reads the spec and produces a technical implementation plan:
- Files to create/change
- Schema changes
- API contract
- Test approach

No code yet — just the blueprint.

### 4. `/tasks <feature-name>`
Breaks the plan into discrete, ordered tasks stored in `specs/<name>/tasks.md`.
Tasks should each be implementable in a single focused session.

### 5. `/tdd <feature-name>`
Maps every acceptance criterion in `spec.md` to a test stub (`it.todo(...)`) and writes
those stubs into co-located test files — before any implementation exists.

This is the **red phase**: tests are present but nothing passes yet.
`/implement` then fills in the stubs (green phase).

> Skip this step only if the feature has zero business logic (e.g. a pure static page).

### 6. `/implement <feature-name>`
Works through `tasks.md` task by task, checking each off as it's completed.
Writes code, tests, and migrations.

At each task boundary, Claude pauses for your review before continuing.

### 7. `/review <feature-name>`
The `reviewer` agent audits the changes against the spec's acceptance criteria,
the project's coding standards (from `CLAUDE.md`), and common failure modes.

Returns APPROVED or CHANGES REQUESTED with specific feedback.

### 7. `/pr <feature-name>`
Creates the GitHub PR with the spec as the PR body. Only run after `/review`
returns APPROVED.

---

## File layout

```
specs/
  <feature-name>/
    spec.md       ← acceptance criteria
    plan.md       ← technical plan
    tasks.md      ← task checklist
```

---

## Resetting

If a spec changes mid-build:
1. Update `spec.md` manually
2. Re-run `/plan` and `/tasks` — do NOT just edit tasks.md by hand
3. Re-run `/implement` from the last completed task

---

## Tips

- Keep specs small. One spec = one PR.
- Acceptance criteria should be verifiable with a test or a screenshot.
- If `/clarify` surfaces blockers (missing API keys, unclear requirements), resolve
  them before `/specify`.
