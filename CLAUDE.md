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
/clarify → /specify → /plan → /tasks → /implement → /review → /pr
```

Never write feature code without a spec in `specs/<feature>/spec.md`.

---

## Code conventions

- TypeScript strict mode. No `any`.
- Validate all inputs with Zod at the boundary (API routes, server actions, forms).
- Server Components by default. Only use `"use client"` when necessary.
- Never import `PrismaClient` directly — use `src/lib/db.ts`.
- Use `src/lib/auth.ts` for session access, never raw JWT manipulation.
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

When executing `/implement`:
1. Do one task at a time.
2. Write the test before or alongside the implementation.
3. Run `npm test` and confirm it passes before moving to the next task.
4. Pause and summarize after each task.

---

## Responding to ambiguity

If a request is unclear, run `/clarify` rather than guessing.
If requirements change mid-spec, update `spec.md` and re-run `/plan`.
If a test fails unexpectedly, run `/analyze` before attempting a fix.
