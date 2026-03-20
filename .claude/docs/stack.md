# Stack Reference

Quick reference for how each technology is used in this project.
Agents read this file to make consistent decisions.

---

## Framework: Next.js 15 (App Router)

- All routes live in `src/app/`
- Server Components by default — add `"use client"` only when needed
- API routes: `src/app/api/<route>/route.ts`
- Use `next/navigation` (not `next/router`)
- Layouts: `layout.tsx`, loading: `loading.tsx`, error: `error.tsx`

## Language: TypeScript (strict)

- `strict: true` in `tsconfig.json`
- No `any` — use `unknown` + type narrowing
- Zod for all runtime validation (forms, API inputs, env vars)

## Auth: Better Auth

- Server config: `src/lib/auth.ts` — `betterAuth()` with `prismaAdapter`
- Client config: `src/lib/auth-client.ts` — `createAuthClient()` from `better-auth/react`
- Session (Server Component): `auth.api.getSession({ headers: await headers() })`
- Session (Client Component): `useSession()` from `src/lib/auth-client.ts`
- Route handler: `src/app/api/auth/[...all]/route.ts`
- Protect routes in middleware via `getSessionCookie` from `better-auth/cookies`
- DB adapter: built into `better-auth` — no separate adapter package needed
- Schema: run `npx @better-auth/cli generate` to append required auth models

## Database: PostgreSQL + Prisma

- Schema: `prisma/schema.prisma`
- Migrations: `npx prisma migrate dev`
- Client: `src/lib/db.ts` (singleton)
- Never import `PrismaClient` directly — use `src/lib/db.ts`

## Styling: Tailwind CSS + shadcn/ui

- Components live in `src/components/ui/`
- Add new shadcn components: `npx shadcn@latest add <component>`
- Custom tokens in `tailwind.config.ts`

## Forms: React Hook Form + Zod

- Schema → Zod → `useForm` with `zodResolver`
- Server actions preferred over API routes for mutations

## Testing

- Unit/integration: Jest (`npm test`)
- E2E: Playwright (`npm run test:e2e`)
- Test files: co-located (`*.test.ts`) or in `tests/`

## Email: Resend + React Email

- Templates: `src/emails/`
- Send via: `src/lib/email.ts`

## File storage: Uploadthing

- Config: `src/lib/uploadthing.ts`

## Payments: Stripe

- Webhooks: `src/app/api/webhooks/stripe/route.ts`
- Client: `src/lib/stripe.ts`

---

## Import aliases

```ts
@/          → src/
@/components → src/components/
@/lib        → src/lib/
@/types      → src/types/
```
