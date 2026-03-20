Generate a requirements quality checklist for: $ARGUMENTS

Checklists test whether requirements are **complete, clear, and consistent** — not whether code works.

---

## Usage

```
/checklist 03-user-settings ux
/checklist 03-user-settings api
/checklist 03-user-settings security
/checklist 03-user-settings pre-implement
```

Format: `/checklist <spec-name> <type>`
If type is omitted, generate `pre-implement`.

---

## Steps

### 1. Read the spec

Load `.claude/specs/<name>/spec.md` and any plan.md.

### 2. Generate checklist by type

#### `ux` — UI/UX requirements quality
```markdown
## UX Checklist: <Feature>

### User Stories
- [ ] All roles that interact with this feature have at least one story
- [ ] Each story has a clear "so that" outcome (not just "I want to X")
- [ ] Stories cover: create, read, update, delete (where applicable)

### States
- [ ] Empty state described (what shows when there's no data)
- [ ] Loading state described
- [ ] Error state described (what the user sees when something fails)
- [ ] Success feedback described (toast, redirect, inline confirmation)

### Interactions
- [ ] Primary action is identifiable (what's the most important thing a user does?)
- [ ] Destructive actions require confirmation
- [ ] Mobile/responsive behavior mentioned

### Accessibility
- [ ] Keyboard navigation mentioned or not applicable
- [ ] Color is not the only way to convey status
```

#### `api` — API requirements quality
```markdown
## API Checklist: <Feature>

### Endpoints
- [ ] Each endpoint has a defined HTTP method and path
- [ ] Request body/params are defined for POST/PATCH
- [ ] Success response shape is defined
- [ ] All error responses are defined (400, 401, 403, 404, 500)

### Auth & Permissions
- [ ] Which roles can call each endpoint is specified
- [ ] Unauthenticated behavior is specified

### Data
- [ ] Input validation rules are defined
- [ ] Edge cases for data (empty arrays, null fields, max length) are specified
```

#### `security` — Security requirements quality
```markdown
## Security Checklist: <Feature>

- [ ] Authentication required on all non-public endpoints
- [ ] Authorization: users can only access their own data (or spec defines exceptions)
- [ ] Input validation defined (prevents injection, XSS)
- [ ] Sensitive data (passwords, tokens) not returned in API responses
- [ ] File uploads (if any): type and size limits defined
- [ ] Rate limiting mentioned for auth or public endpoints
```

#### `pre-implement` — General readiness
```markdown
## Pre-Implementation Checklist: <Feature>

### Spec Quality
- [ ] All acceptance criteria are testable (pass/fail, not subjective)
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Out of Scope section prevents scope creep

### Plan Quality
- [ ] Feature branch name defined
- [ ] Schema changes are specific (field names, types, relations)
- [ ] No plan decisions contradict spec or CLAUDE.md constraints

### Tasks Quality (if tasks.md exists)
- [ ] Every code task has a paired test task
- [ ] Tasks are ordered (dependencies before dependents)
- [ ] Build/lint/typecheck is the final task
```

### 3. Write file

Save to `.claude/specs/<name>/checklists/<type>.md`.

### 4. Confirm

Report which items need attention before proceeding.
