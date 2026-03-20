Execute implementation for: $ARGUMENTS

**Use the specialized agents for all code work. Do NOT write code on the main thread.**

- `coder` agent — all implementation tasks
- `test-writer` agent — tests after each code task
- `reviewer` agent — final review before committing

---

## Prerequisites

```
[ ] On branch spec/<name>
[ ] tasks.md exists at .claude/specs/<name>/tasks.md
[ ] No uncommitted changes
```

---

## Steps

### 1. Validate

Confirm branch and tasks.md exist. If tasks.md is missing, tell the user to run `/tasks` first.

### 2. Read context

Before starting, read:
- `CLAUDE.md` — project constraints, prohibited patterns, immutable models
- `.claude/specs/<name>/spec.md` — what to build
- `.claude/specs/<name>/plan.md` — how to build it
- `.claude/specs/<name>/tasks.md` — the ordered task list

### 3. Implement each task group in order

For each group in tasks.md:

**Schema/Data tasks** → dispatch `coder` agent with:
- The specific schema changes from plan.md
- Instructions to run `npm run db:push` after changes
- Convention: no changes to models marked immutable in CLAUDE.md

**API tasks** → dispatch `coder` agent, then immediately dispatch `test-writer` agent with:
- The newly created route file paths
- Required test coverage: 200, 400, 401/403, 404, 500

**Server action tasks** → dispatch `coder` then `test-writer`

**UI/component tasks** → dispatch `coder` for data wiring only (no layout/design decisions):
- The design agent will own visual design; `coder` only wires data and props
- Then dispatch `test-writer` for render tests

**E2E tasks** → dispatch `test-writer` agent with:
- The feature flow to test
- Auth bypass pattern from `.claude/docs/dev-auth-bypass.md`

### 4. Quality gate

After all tasks are complete, run in sequence:
```bash
npm run typecheck
npm run lint
npm test
npm run test:e2e
```

Fix any failures before proceeding.

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
