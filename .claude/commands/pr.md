Create a pull request for spec: $ARGUMENTS

Use after `/review` passes (APPROVED verdict).

---

## Steps

### 1. Verify branch and review status

```bash
git status
git log main..HEAD --oneline
```

Confirm:
- On branch `spec/<name>`
- Review has been run and returned APPROVED

### 2. Summarize changes

Collect commit messages and changed files.
Read `specs/<name>/spec.md` for the acceptance criteria.

### 3. Push branch

```bash
git push -u origin spec/<name>
```

### 4. Create PR via gh CLI

```bash
gh pr create \
  --title "feat: <Feature Name>" \
  --body "$(cat specs/<name>/spec.md)" \
  --base main \
  --head spec/<name>
```

PR body template:
```markdown
## What
<one-line summary>

## Spec
<paste acceptance criteria from spec.md>

## Testing
- [ ] Unit tests pass: `npm test`
- [ ] E2E tests pass: `npm run test:e2e`
- [ ] Manual smoke test in dev

## Screenshots
<if UI changes>
```

### 5. Output

Return the PR URL.
