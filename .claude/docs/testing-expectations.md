# Testing Expectations

Standards for test coverage and quality in this project.
Read by the `reviewer`, `test-writer`, and `/tdd` command.

---

## TDD: Tests Before Code

Tests are written in the `/tdd` phase, before any implementation exists.
`/implement` writes code to make those tests pass.

**Red → Green → Refactor:**
1. `/tdd` writes real failing tests (import errors = correct red state)
2. `/implement` writes code until tests pass (green)
3. `reviewer` checks for unnecessary complexity (refactor)

Do not write tests after the fact. Do not use `it.todo()` — it is a checklist,
not a test, and provides zero signal during development.

---

## Coverage Requirements by Code Type

| Code Type | Minimum Tests Required |
|-----------|----------------------|
| Validation schema | 3+ (valid input, invalid input, edge cases) |
| API route | 1 per HTTP method + 401 unauthenticated + 500 DB error |
| Server action | success path + validation error + auth error |
| React component | render test + primary interaction test |
| E2E user flow | happy path + at least one error/edge case |

---

## Unit & Integration Tests (Jest)

### File Location

Co-locate test files with source:
```
src/
  components/
    UserCard.tsx
    UserCard.test.tsx        ← co-located
  app/api/users/
    route.ts
    route.test.ts            ← co-located
```

### Test Structure

```typescript
describe('ComponentOrFunctionName', () => {
  it('does the primary thing', () => { ... })
  it('handles the edge case', () => { ... })
  it('returns error on invalid input', () => { ... })
})
```

### API Route Test Checklist

Every route must cover:
- [ ] `200` — success with valid auth + input
- [ ] `400` — invalid request body
- [ ] `401` — unauthenticated request
- [ ] `403` — authenticated but unauthorized (if roles exist)
- [ ] `404` — resource not found (for `[id]` routes)
- [ ] `500` — database/unexpected error

---

## E2E Tests (Playwright)

### File Location

```
e2e/
  feature-name.spec.ts
```

### Required Coverage per Feature

- [ ] Happy path: full user flow from entry to completion
- [ ] Error state: what happens when something fails
- [ ] Auth boundary: unauthenticated user is redirected

### Selector Rules

```typescript
// ✅ ALLOWED — stable selectors
page.getByTestId('submit-button')
page.getByRole('button', { name: /submit/i })
page.getByText('Expected text')
page.locator('[data-testid="..."]')

// ❌ BANNED — fragile in CI
page.locator('svg')
page.locator('> div')
page.locator('#some-id')
page.locator('.class-name')
```

Add `data-testid` attributes to source components rather than using CSS workarounds.

### Timeout Guidelines

| Assertion | Minimum Timeout |
|-----------|----------------|
| Dialog/modal visible | `{ timeout: 5000 }` |
| Item appears after save | `{ timeout: 10000 }` |
| Page navigation | `{ timeout: 10000 }` |

---

## PR Checklist (Before `/review`)

- [ ] New behavior has unit tests
- [ ] Bug fixes have a regression test
- [ ] API routes cover all status codes listed above
- [ ] E2E covers the happy path
- [ ] No tests deleted or skipped without justification
- [ ] `npm test` passes
- [ ] `npm run test:e2e` passes
- [ ] `npm run typecheck` passes
- [ ] `npm run lint` passes

---

## What Counts as "Tested"

**Yes:**
- Jest unit test that runs in CI
- Playwright E2E test that runs in CI

**No:**
- Manual testing noted in a comment
- `console.log` checking during dev
- A test marked `.skip` or `.todo`
- A test written after the implementation it covers

---

## Mocking Strategy

- Mock at the module boundary (database, auth, external APIs)
- Don't mock internal helpers — test them directly
- Use `jest.fn()` for callbacks, not implementation stubs

```typescript
// Mock DB at the boundary
jest.mock('@/lib/db', () => ({
  default: {
    user: { findMany: jest.fn(), create: jest.fn() },
  },
}))

// Mock auth at the boundary
jest.mock('@/lib/auth', () => ({
  auth: jest.fn(),
}))
```
