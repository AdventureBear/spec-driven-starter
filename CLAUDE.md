# Claude Instructions

This file is read by Claude Code at the start of every session.
It defines how Claude should behave in this project.

---

## Project context

Read `PROJECT_SPEC.md` at the start of every session to understand the product.
Read `.claude/docs/stack.md` to understand the tech stack and conventions.
Read `.claude/docs/workflow.md` to understand the development process.

---

## Workflow

Always follow the spec-driven workflow:

```
/clarify → /specify → /plan → /tasks → /tdd → /implement → /review → /pr
```

Never write feature code without a spec in `specs/<feature>/spec.md`.

---

## Code conventions

- TypeScript strict mode. No `any`.
- Validate all inputs with Zod at the boundary (API routes, server actions, forms).
- Server Components by default. Only use `"use client"` when necessary.
- Never import `PrismaClient` directly — use `src/lib/db.ts`.
- Use `auth()` from `src/lib/auth.ts` for session access in Server Components — never call `getServerSession` directly.
- Co-locate tests with source files (`*.test.ts`).
- Prefer editing existing files over creating new ones.
- Keep components small and focused.

---

## What NOT to do

- Never push to `main` directly.
- Never skip writing tests for a task.
- Never mark a task complete if its tests are failing.
- Never expose secrets in client-side code.
- Never delete database records without a confirmation step.
- Never use `force push` without explicit user permission.

---

## Task discipline

When executing `/tdd`:
1. Read every acceptance criterion in `spec.md` and the API contract in `plan.md`.
2. Write real, executable failing tests — no `it.todo()`, no stubs, real `expect()` assertions.
3. Test descriptions must describe what the user sees or can do, not implementation details.
4. Tests must fail for the right reason: missing module (import error), not a logic error.
5. Do not write any implementation code during this phase.

When executing `/implement`:
1. Do one task at a time.
2. Write implementation code to make the failing tests from `/tdd` pass — do not write new tests or invent new assertions.
3. Run `npm test` and confirm the previously-failing tests now pass before moving to the next task.
4. Pause and summarize after each task.

---

## Responding to ambiguity

If a request is unclear, run `/clarify` rather than guessing.
If requirements change mid-spec, update `spec.md` and re-run `/plan`.
If a test fails unexpectedly, run `/analyze` before attempting a fix.
