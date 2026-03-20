Create a technical implementation plan for: $ARGUMENTS

**⛔ DO NOT write any code. DO NOT enter plan mode.** This command produces planning documents only.

## Prerequisites

- Spec must exist at `.claude/specs/<name>/spec.md`
- Run `/clarify` first if the spec has `[NEEDS CLARIFICATION]` markers
- Recommended: run `/checklist <name> pre-implement` before planning

---

## Steps

### 1. Validate

Check `.claude/specs/<name>/spec.md` exists. If not, tell the user to run `/specify` first.
Check for any `[NEEDS CLARIFICATION]` markers — warn but do not stop.

### 2. Create feature branch

```bash
git checkout main
git pull --ff-only
git checkout -b spec/<name>
```

### 3. Read constraints

Read `CLAUDE.md` in full before planning. Note any:
- Prohibited components or patterns
- Immutable models (do not modify)
- Required conventions

### 4. Write plan.md

Create `.claude/specs/<name>/plan.md`:

```markdown
# Plan: Feature Name

## Architecture Overview
How this feature fits into the existing app structure.

## Data Model Changes
- New models or fields needed in prisma/schema.prisma
- Migrations required
- Seed data changes

## API Changes
- New routes: METHOD /api/path — description
- Modified routes: what changes and why

## Component / UI Changes
NOTE: No UI will be built here. The design agent will scaffold UI fresh.
- List what data needs to be available to the UI layer
- List any server actions or API hooks the UI will call

## Architecture Decisions
| Decision | Options Considered | Choice | Reason |
|----------|-------------------|--------|--------|

## Risks
- Risk description → mitigation

## Dependencies
- What must be complete before this spec can start
- What this spec blocks
```

### 5. Confirm

Output the branch name and plan summary. Ask if any section needs revision before running `/tasks`.
