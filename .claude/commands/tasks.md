Generate an implementation task checklist for: $ARGUMENTS

## Prerequisites

- Spec: `.claude/specs/<name>/spec.md`
- Plan: `.claude/specs/<name>/plan.md`
- Branch: `spec/<name>` (created by `/plan`)

---

## Steps

### 1. Validate

Check that both `spec.md` and `plan.md` exist. If not, stop and tell the user what's missing.

### 2. Move GitHub issues to In Progress

If `spec.md` has a `GitHub Issues:` field with issue numbers, move them to "In Progress" on the project board:

```bash
# UPDATE: replace --owner and --project-id with your values
# Get item ID:
# gh project item-list 1 --owner YOUR_GITHUB_USERNAME --format json --limit 100

# Move to In Progress:
# gh project item-edit --project-id YOUR_PROJECT_ID --id "$ITEM_ID" \
#   --field-id YOUR_STATUS_FIELD_ID --single-select-option-id YOUR_IN_PROGRESS_OPTION_ID
```

Skip if no project board is configured.

### 3. Read testing requirements

Read `.claude/docs/testing-expectations.md` before generating test tasks.
Every code task must have a paired test task.

### 4. Generate tasks.md

Create `.claude/specs/<name>/tasks.md`:

```markdown
# Tasks: Feature Name

**Spec**: .claude/specs/<name>/spec.md
**Plan**: .claude/specs/<name>/plan.md
**Branch**: spec/<name>

## Pre-flight
- [ ] On branch `spec/<name>`
- [ ] Branch up to date with main

## Schema & Data
- [ ] Add/modify models in prisma/schema.prisma
- [ ] Run `npm run db:push` to apply schema changes
- [ ] Update seed file if needed
- [ ] Run `npm run db:seed` to verify seed runs clean

## API Layer
- [ ] Implement GET /api/... route
- [ ] Implement POST /api/... route
- [ ] Write unit tests for each route (200, 400, 401, 500)

## Server Actions / Business Logic
- [ ] Implement <action> server action
- [ ] Write unit tests for server action (success, error cases)

## UI / Components
<!-- NOTE: UI is scaffolded fresh by the design agent. -->
<!-- List only what data contracts / props the UI will need. -->
- [ ] Define props interface for <ComponentName>
- [ ] Wire component to API (React Query hook or server component)
- [ ] Write component render test

## E2E Tests
- [ ] Write Playwright test: happy path (create → read → update)
- [ ] Write Playwright test: error/edge case

## Quality Gate
- [ ] `npm run build` passes with no type errors
- [ ] `npm run lint` passes
- [ ] `npm test` passes
- [ ] `npm run test:e2e` passes
- [ ] Reviewed by `reviewer` agent

## Commit
- [ ] Commit with message: `feat(<name>): <summary>`
```

### 5. Confirm

Output the tasks file path and count of tasks. Ask if anything is missing before running `/implement`.
