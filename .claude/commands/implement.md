Execute implementation for: $ARGUMENTS

**Use the specialized agents for all code work. Do NOT write code on the main thread.**

- `coder` agent — all implementation tasks
- `reviewer` agent — final review before committing

The `test-writer` agent is NOT dispatched during implementation. Tests were written in
the `/tdd` phase. Your job here is to make those tests pass, not write new ones.

---

## Prerequisites

```
[ ] On branch spec/<name>
[ ] tasks.md exists at .claude/specs/<name>/tasks.md
[ ] TDD test files exist (written by /tdd)
[ ] No uncommitted changes
```

---

## Steps

### 1. Validate

Confirm branch and tasks.md exist. If tasks.md is missing, tell the user to run `/tasks`
first. Check that test files for this feature exist — if none exist, tell the user to
run `/tdd` first before implementing.

### 2. Read context

Before starting, read:
- `CLAUDE.md` — project constraints, prohibited patterns, immutable models
- `.claude/specs/<name>/spec.md` — what to build
- `.claude/specs/<name>/plan.md` — how to build it
- `.claude/specs/<name>/tasks.md` — the ordered task list
- All test files written by `/tdd` — these define the contract you must satisfy

### 3. Implement each task group in order

For each group in tasks.md:

**Schema/Data tasks** → dispatch `coder` agent with:
- The specific schema changes from plan.md
- Instructions to run `npm run db:push` after changes
- Convention: no changes to models marked immutable in CLAUDE.md

**API tasks** → dispatch `coder` agent to create the route, then run:
```bash
npm test -- --testPathPattern="route.test"
```
Tests were written in the `/tdd` phase — verify they now pass before moving on.

**Server action tasks** → dispatch `coder` agent, then run tests for the action file.
All tests should turn green; if any fail, fix the implementation (not the test).

**UI/component tasks** → dispatch `coder` agent for data wiring only (no layout/design
decisions). The design agent owns visual design; `coder` only wires data and props.
After each component, run its co-located test and verify green.

### 4. Quality gate

After all tasks are complete, run in sequence:
```bash
npm run typecheck
npm run lint
npm test
npm run test:e2e
```

All must pass. Fix any failures before proceeding. Do not comment out, skip, or delete
failing tests — fix the implementation.

### 5. Review

Dispatch `reviewer` agent with:
- List of all modified files
- The spec acceptance criteria to verify against

Address any blocking issues before committing.

### 6. Commit

```bash
git add -p   # stage intentionally, not blindly
git commit -m "feat(<name>): <summary of what was built>"
```
