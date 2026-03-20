# Spec-Driven Next.js Starter

A lean template for starting new Next.js projects with a spec-driven development
workflow powered by Claude Code.

**This repo does not contain a Next.js app.** It contains the tools to start one correctly.

---

## What's included

| File / Folder | Purpose |
|---|---|
| `package.json` | All dependencies — pinned, up to date |
| `CLAUDE.md` | Claude Code instructions for this project |
| `PROJECT_SPEC.md` | Template: describe your product here |
| `.env.example` | All environment variables you'll need |
| `.claude/commands/` | Slash commands: `/specify`, `/plan`, `/implement`, etc. |
| `.claude/agents/` | Sub-agents: planner, specifier, implementer, reviewer, analyzer |
| `.claude/docs/` | Stack reference and workflow guide |
| `scripts/bootstrap.sh` | Post-install setup (run once after `npm install`) |
| `scripts/check-versions.sh` | Check for newer package versions |

---

## Quick start

### Step 1 — Create a new Next.js app

Use the official CLI to scaffold a fresh project:

```bash
npx create-next-app@latest my-app \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*"
cd my-app
```

### Step 2 — Copy this repo's files into your new project

```bash
# From the root of your new Next.js project:
cp -r /path/to/spec-driven-starter/.claude .
cp /path/to/spec-driven-starter/CLAUDE.md .
cp /path/to/spec-driven-starter/PROJECT_SPEC.md .
cp /path/to/spec-driven-starter/.env.example .
cp -r /path/to/spec-driven-starter/scripts .
```

Or clone this repo alongside your project and run:

```bash
bash /path/to/spec-driven-starter/scripts/copy-to.sh /path/to/my-app
```

### Step 3 — Merge package.json dependencies

Open `package.json` from this repo and add the missing dependencies to your
new project's `package.json`. Then install:

```bash
npm install
```

> **Tip:** Run `scripts/check-versions.sh` first to see if any packages have
> newer versions available before installing.

### Step 4 — Configure environment variables

```bash
cp .env.example .env.local
# Edit .env.local — fill in DATABASE_URL, AUTH_SECRET, and any services you'll use
```

Generate `AUTH_SECRET`:
```bash
openssl rand -base64 32
```

### Step 5 — Run bootstrap setup

```bash
bash scripts/bootstrap.sh
```

This creates `prisma/seed/`, runs `prisma generate`, and installs Playwright browsers.

### Step 6 — Fill in your project spec

Open `PROJECT_SPEC.md` and fill in every section.
This is what Claude reads to understand your product.

---

## Using Claude Code

Once your project is set up, open it in Claude Code and use the workflow commands:

```
/clarify <feature>   — Talk through a feature before writing specs
/specify <feature>   — Write a formal spec with acceptance criteria
/plan <feature>      — Generate a technical implementation plan
/tasks <feature>     — Break the plan into discrete tasks
/implement <feature> — Build it, task by task, with tests
/review <feature>    — Audit changes against the spec
/pr <feature>        — Open a GitHub PR
/analyze <issue>     — Investigate a bug
/checklist           — Pre-launch quality checklist
```

See `.claude/docs/workflow.md` for the full workflow guide.

---

## Keeping dependencies up to date

Check for newer versions of all packages:

```bash
npm run check-versions
# or
bash scripts/check-versions.sh
```

Upgrade all packages to latest:

```bash
npm run check-versions:upgrade
```

This uses [npm-check-updates](https://github.com/raineorshine/npm-check-updates).
Run it periodically or before starting a new project.

---

## Stack

| Layer | Technology |
|---|---|
| Framework | Next.js 15, App Router |
| Language | TypeScript (strict) |
| Auth | NextAuth.js / Auth.js v5 |
| Database | PostgreSQL + Prisma ORM |
| Styling | Tailwind CSS v4 + shadcn/ui |
| Forms | React Hook Form + Zod |
| Testing | Vitest + Playwright |
| State | Zustand + TanStack Query |
| Email | Resend + React Email |
| Uploads | Uploadthing |
| Payments | Stripe |

See `.claude/docs/stack.md` for conventions and usage patterns.

---

## Updating this starter

When you want to update the Claude system (commands, agents, docs) in an existing project:

1. Pull the latest version of this repo
2. Copy `.claude/` into your project (overwrite)
3. Review any breaking changes in `CLAUDE.md`
