# Spec-Driven Next.js Starter

A template for starting new Next.js projects with a spec-driven development
workflow powered by Claude Code.

Clone it, describe your product, run one command, then let Claude build the MVP.

---

## Quick start

### 1. Clone and describe your product

```bash
git clone https://github.com/AdventureBear/spec-driven-starter my-app
cd my-app
```

Open `PROJECT_SPEC.md` and fill in every section — this is what Claude reads
to understand what to build.

### 2. Scaffold the app

```bash
npm run setup
```

This creates the full Next.js app skeleton (tsconfig, app dir, Prisma schema,
Jest, Playwright, ESLint configs) and runs `npm install`.

### 3. Configure environment variables

```bash
# .env.local was created by setup — open it and fill in:
#   DATABASE_URL   — your PostgreSQL connection string
#   AUTH_SECRET    — run: openssl rand -base64 32
```

### 4. Start the database and push schema

```bash
npm run db:start   # starts PostgreSQL via Docker Compose
npm run db:push    # pushes prisma/schema.prisma to the database
```

### 5. Open in Claude Code and build

```bash
claude
```

Claude reads `PROJECT_SPEC.md` and is ready to scaffold your first feature.
Start with `/specify <feature>` or just describe what you want to build.

---

## What's included

| File / Folder | Purpose |
|---|---|
| `PROJECT_SPEC.md` | Describe your product here — Claude reads this every session |
| `CLAUDE.md` | Claude Code instructions and code conventions |
| `.env.example` | All environment variables you'll need |
| `.claude/commands/` | Slash commands: `/specify`, `/plan`, `/implement`, etc. |
| `.claude/agents/` | Sub-agents: coder, reviewer, test-writer, design-reviewer |
| `.claude/docs/` | Stack reference and workflow guide |
| `scripts/setup.sh` | One-command app scaffold (run once) |
| `scripts/bootstrap.sh` | Post-setup extras: prisma generate, Playwright install |
| `scripts/check-versions.sh` | Check for newer package versions |
| `scripts/wt-*` | Git worktree helpers for feature branches |

---

## What `npm run setup` creates

```
src/
  app/
    layout.tsx          — root layout with Tailwind
    page.tsx            — placeholder home page
    globals.css         — Tailwind v4 import
    api/auth/[...nextauth]/route.ts
  lib/
    db.ts               — Prisma client singleton
    auth.ts             — NextAuth config + getSession helper
  components/           — empty, ready for your components
prisma/
  schema.prisma         — PostgreSQL datasource, no models yet
  seed/seed.ts          — seed script placeholder
tests/e2e/              — Playwright test directory
tsconfig.json
next.config.ts
postcss.config.mjs
eslint.config.mjs
jest.config.ts
jest.setup.ts
playwright.config.ts
.env.local              — copied from .env.example
```

Claude scaffolds the actual models and features from `PROJECT_SPEC.md`.

---

## Claude workflow

Once set up, use these slash commands in Claude Code:

```
/clarify <feature>   — Talk through a feature before writing specs
/specify <feature>   — Write a formal spec with acceptance criteria
/plan <feature>      — Generate a technical implementation plan
/tasks <feature>     — Break the plan into discrete tasks
/tdd <feature>       — Write failing tests first
/implement <feature> — Build it, task by task
/review <feature>    — Audit changes against the spec
/pr <feature>        — Open a GitHub PR
/analyze <issue>     — Investigate a bug
/checklist           — Pre-launch quality checklist
```

See `.claude/docs/workflow.md` for the full workflow guide.

---

## Stack

| Layer | Technology |
|---|---|
| Framework | Next.js 16, App Router |
| Language | TypeScript (strict) |
| Auth | NextAuth.js v4 |
| Database | PostgreSQL + Prisma ORM |
| Styling | Tailwind CSS v4 |
| Forms | React Hook Form + Zod |
| Testing | Jest + Playwright |
| State | Zustand + TanStack Query |

See `.claude/docs/stack.md` for conventions and usage patterns.

---

## Keeping dependencies up to date

```bash
npm run check-versions          # see available updates
npm run check-versions:upgrade  # upgrade all and reinstall
```

---

## Updating the Claude system in an existing project

1. Pull the latest version of this repo
2. Copy `.claude/` into your project (overwrite)
3. Review any changes in `CLAUDE.md`
