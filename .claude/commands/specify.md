Create a feature specification for: $ARGUMENTS

## Modes

- **Keyword**: `/specify user-notifications` — searches _roadmap.md for a match, extracts context
- **Description**: `/specify add email notifications for new comments` — writes spec from scratch
- **Digest**: `/specify digest` — lists all existing specs with one-line summaries

---

## Steps

### 1. Determine mode

Read `specs/_roadmap.md` (if it exists). Search for `$ARGUMENTS` as a keyword.
- If found: extract the feature row (description, priority, notes) and use as input
- If not found: use `$ARGUMENTS` as the description directly
- If `$ARGUMENTS == "digest"`: list all `specs/[0-9]*/spec.md` files with one-line summaries, then stop

### 2. Assign spec number

List **all** existing spec folders — both active and archived — to find the true highest number:

```bash
ls specs/ specs/archive/ 2>/dev/null | grep -E '^[0-9]'
```

Parse each folder name to extract its numeric prefix (e.g. `04-library-ui` → 4, `11b-training-plan-builder` → 11). The next spec number = highest found + 1.

For sub-features of an existing spec, use letter suffixes (e.g. `11a`, `11b`).

Spec folder: `specs/NN-feature-name/`

### 3. Write spec.md

Create `specs/NN-feature-name/spec.md`:

```markdown
# Spec NN: Feature Name

**Status**: Draft
**GitHub Issues**: (link any related issues)

## Overview
One paragraph describing what this feature is and why it matters.

## Problem
What problem does this solve? Who experiences it?

## Goals
- Bulleted intended outcomes

## Non-Goals
- Explicitly out of scope (what this spec will NOT do)

## User Stories
- As a [role], I want to [action] so that [outcome].

## Functional Requirements
FR-001: ...
FR-002: ...

## Acceptance Criteria
- [ ] Testable condition that must be true for the feature to be complete

## Out of Scope
- Items deferred to future specs
```

### 4. Update roadmap

If this spec was created from a roadmap keyword, move it from the roadmap table to a "Specced" section referencing the spec folder.

### 5. Confirm

Output the spec number, folder path, and summary. Ask if any section needs revision, then suggest:

```
Next step: /create-worktree NN-feature-name
```
