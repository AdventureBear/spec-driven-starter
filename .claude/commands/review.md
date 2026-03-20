Review code changes for: $ARGUMENTS

Delegates to the `reviewer` agent. Use after implementing a feature or before opening a PR.

---

## Steps

### 1. Determine scope

If `$ARGUMENTS` is a spec name, review files changed on branch `spec/<name>`.
If `$ARGUMENTS` is a file path or list of files, review those.
If empty, review all staged/unstaged changes vs main.

```bash
git diff main --name-only
```

### 2. Dispatch `reviewer` agent

Pass the agent:
- The list of changed files
- The spec's acceptance criteria (from `spec.md` if available)
- Instructions to check against `CLAUDE.md` constraints

### 3. Report findings

The reviewer agent returns a structured report:

```
## Review: <Feature>

### Blocking Issues
Must fix before merge.

### Warnings
Should address.

### Suggestions
Optional improvements.

### Verdict
APPROVED / CHANGES REQUESTED
```

If CHANGES REQUESTED: list the fixes needed and do not proceed to `/pr`.
If APPROVED: confirm it's safe to run `/pr`.
