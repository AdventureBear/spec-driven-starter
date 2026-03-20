Write failing tests (TDD Red phase) for: $ARGUMENTS

Write real, executable tests derived from acceptance criteria *before any implementation exists*.
Tests fail because the source files don't exist yet. `/implement` makes them pass.
This is Red → Green → Refactor. Do not use `it.todo()` — write real assertions.

Read `.claude/docs/testing-expectations.md` in full before writing any test.

---

## Prerequisites

```
[ ] Spec: .claude/specs/<name>/spec.md
[ ] Plan: .claude/specs/<name>/plan.md
[ ] Tasks: .claude/specs/<name>/tasks.md
[ ] Branch: spec/<name>
[ ] No implementation files exist yet for this feature
```

---

## Steps

### 1. Validate

Check that `spec.md`, `plan.md`, and `tasks.md` all exist. If any are missing, stop and
tell the user which command to run first. This command must run before `/implement`.

### 2. Read context — in this order

1. `.claude/specs/<name>/spec.md` — Acceptance Criteria drive every test description
2. `.claude/specs/<name>/plan.md` — API contracts, action signatures, and component props
3. `.claude/specs/<name>/tasks.md` — tells you which file paths will be created
4. `.claude/docs/testing-expectations.md` — test design principles (required)

### 3. Map each AC to a test layer

Before writing any file, decide which layer covers each acceptance criterion:

| Criterion type | Layer |
|---|---|
| Business rule / data validation | Server action or API route unit test |
| Auth / permission boundary | Server action or API route unit test |
| User can see X | Component integration test |
| User can do X (click, submit, navigate) | Component integration test or E2E |
| Full user journey end-to-end | E2E |

Every AC must map to at least one test. If an AC is untestable as written, flag it.

### 4. Write failing tests by layer

Tests import from the paths defined in `plan.md`. Those files do not exist yet — the
import failure is the intended red state. Write real `expect(...)` assertions, not
`.todo()` placeholders.

---

#### Server Action tests → `src/<path>/<action>.test.ts`

Import the action that will be created. Tests fail with "module not found" until
`/implement` creates the file.

```typescript
/**
 * @jest-environment node
 * Tests for <ActionName> — written before implementation (TDD Red phase)
 * AC coverage: <list which spec ACs this file covers>
 */
import { <actionName> } from './<action>'

// Mock at the boundary — not the action itself
jest.mock('@/lib/db', () => ({ default: { <model>: { create: jest.fn(), findMany: jest.fn() } } }))
jest.mock('@/lib/auth', () => ({ auth: jest.fn() }))

import db from '@/lib/db'
import { auth } from '@/lib/auth'

const mockUser = { id: 'user-1', email: 'user@example.com' }

describe('<actionName>', () => {
  beforeEach(() => jest.clearAllMocks())

  // AC: <paste the acceptance criterion text>
  it('returns success data when authenticated user submits valid input', async () => {
    ;(auth as jest.Mock).mockResolvedValue({ user: mockUser })
    ;(db.<model>.create as jest.Mock).mockResolvedValue({ id: 'new-1', ... })

    const result = await <actionName>({ /* valid input from plan.md */ })

    expect(result.success).toBe(true)
    expect(result.data).toMatchObject({ /* expected shape */ })
  })

  // AC: <paste the AC this covers>
  it('returns validation errors when required fields are missing', async () => {
    ;(auth as jest.Mock).mockResolvedValue({ user: mockUser })

    const result = await <actionName>({})

    expect(result.success).toBe(false)
    expect(result.errors).toHaveProperty('<fieldName>')
  })

  // Auth boundary — always required
  it('returns unauthorized when called without a session', async () => {
    ;(auth as jest.Mock).mockResolvedValue(null)

    const result = await <actionName>({ /* valid input */ })

    expect(result.success).toBe(false)
    expect(result.error).toMatch(/unauthorized/i)
  })
})
```

---

#### API Route tests → `src/app/api/<route>/route.test.ts`

```typescript
/**
 * @jest-environment node
 * Tests for <METHOD> /api/<route> — written before implementation (TDD Red phase)
 * AC coverage: <list ACs>
 */
import { <METHOD> } from './route'
import { NextRequest } from 'next/server'

jest.mock('@/lib/db', () => ({ default: { <model>: { findMany: jest.fn() } } }))
jest.mock('@/lib/auth', () => ({ auth: jest.fn() }))

import db from '@/lib/db'
import { auth } from '@/lib/auth'

describe('<METHOD> /api/<route>', () => {
  beforeEach(() => jest.clearAllMocks())

  it('returns 200 with <data description> for authenticated user', async () => {
    ;(auth as jest.Mock).mockResolvedValue({ user: { id: '1' } })
    ;(db.<model>.findMany as jest.Mock).mockResolvedValue([{ id: '1', ... }])

    const res = await <METHOD>(new NextRequest('http://localhost/api/<route>'))

    expect(res.status).toBe(200)
    const body = await res.json()
    expect(body).toMatchObject([{ id: '1' }])
  })

  it('returns 401 when request has no session', async () => {
    ;(auth as jest.Mock).mockResolvedValue(null)
    const res = await <METHOD>(new NextRequest('http://localhost/api/<route>'))
    expect(res.status).toBe(401)
  })

  it('returns 400 when request body is invalid', async () => {
    ;(auth as jest.Mock).mockResolvedValue({ user: { id: '1' } })
    const req = new NextRequest('http://localhost/api/<route>', {
      method: '<METHOD>',
      body: JSON.stringify({ /* intentionally missing required fields */ }),
    })
    const res = await <METHOD>(req)
    expect(res.status).toBe(400)
  })

  it('returns 500 when database throws', async () => {
    ;(auth as jest.Mock).mockResolvedValue({ user: { id: '1' } })
    ;(db.<model>.findMany as jest.Mock).mockRejectedValue(new Error('DB down'))
    const res = await <METHOD>(new NextRequest('http://localhost/api/<route>'))
    expect(res.status).toBe(500)
  })
})
```

---

#### Component tests → `src/<path>/<Component>.test.tsx`

Test what the **user sees and can do**, derived directly from the AC.
Do not test props, CSS, DOM structure, or internal state.

```typescript
/**
 * Tests for <ComponentName> — written before implementation (TDD Red phase)
 * AC coverage: <list ACs>
 */
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { <ComponentName> } from './<Component>'

// Only mock at the module boundary (data fetching hooks, actions)
jest.mock('@/lib/hooks/use<Data>', () => ({ use<Data>: jest.fn() }))
import { use<Data> } from '@/lib/hooks/use<Data>'

describe('<ComponentName>', () => {
  // AC: "User can see <X> when <condition>"
  it('displays <content> when data is loaded', () => {
    ;(use<Data> as jest.Mock).mockReturnValue({ data: [{ id: '1', name: 'Example' }], isLoading: false })
    render(<ComponentName />)
    expect(screen.getByText('Example')).toBeInTheDocument()
  })

  // AC: "User can perform <action>"
  it('calls <action> when user submits the form', async () => {
    const user = userEvent.setup()
    const mockAction = jest.fn().mockResolvedValue({ success: true })
    render(<ComponentName onSubmit={mockAction} />)

    await user.type(screen.getByRole('textbox', { name: /<label>/i }), 'my input')
    await user.click(screen.getByRole('button', { name: /<submit label>/i }))

    await waitFor(() => expect(mockAction).toHaveBeenCalledWith(
      expect.objectContaining({ <field>: 'my input' })
    ))
  })

  // AC: "Error is shown when <failure condition>"
  it('shows an error message when submission fails', async () => {
    const user = userEvent.setup()
    const mockAction = jest.fn().mockResolvedValue({ success: false, error: 'Something went wrong' })
    render(<ComponentName onSubmit={mockAction} />)

    await user.click(screen.getByRole('button', { name: /<submit label>/i }))

    expect(await screen.findByRole('alert')).toHaveTextContent('Something went wrong')
  })
})
```

---

#### E2E tests → `e2e/<feature-name>.spec.ts`

Map the full user journey from the spec's user stories.

```typescript
/**
 * E2E tests for <Feature Name> — written before implementation (TDD Red phase)
 * AC coverage: <list ACs>
 */
import { test, expect } from '@playwright/test'

test.describe('<Feature Name>', () => {
  test.beforeEach(async ({ context }) => {
    await context.addCookies([{
      name: 'dev-role', value: 'User', domain: 'localhost', path: '/',
    }])
  })

  // Maps to: AC "User can complete <full flow>"
  test('happy path: user can <describe the journey in plain language>', async ({ page }) => {
    await page.goto('/<route>')
    // Step through the user journey described in spec.md user stories
    await page.getByRole('button', { name: /<action>/i }).click()
    await page.getByRole('textbox', { name: /<label>/i }).fill('test value')
    await page.getByRole('button', { name: /submit/i }).click()
    await expect(page.getByText('test value')).toBeVisible({ timeout: 5000 })
  })

  // Maps to: AC "User sees error when <condition>"
  test('error path: user sees <error> when <condition>', async ({ page }) => {
    await page.goto('/<route>')
    await page.getByRole('button', { name: /submit/i }).click()  // submit empty
    await expect(page.getByRole('alert')).toBeVisible()
  })

  // Always required
  test('auth boundary: unauthenticated user is redirected to login', async ({ browser }) => {
    const context = await browser.newContext()  // no auth cookie
    const page = await context.newPage()
    await page.goto('/<route>')
    await expect(page).toHaveURL(/\/login/)
  })
})
```

---

### 5. Confirm red state

Run: `npm test -- --testPathPattern="<name>" 2>&1 | tail -20`

Expected: tests fail with **module not found** or **import errors** (because implementation
doesn't exist yet). This is correct. If a test passes without any implementation, it is
testing nothing — flag it and rewrite the assertion.

Do NOT run E2E tests in the red phase (the app isn't running). They will be verified
green in the quality gate at the end of `/implement`.

### 6. Report and hand off

Output:
- Files created, paths, and count of tests per file
- Which spec ACs each file covers
- Confirm all tests are failing for the right reason (import error, not logic error)
- Any AC that could not be mapped to a test

Tell the user: "Tests are red. Run `/implement <name>` to write the implementation
and turn them green."
