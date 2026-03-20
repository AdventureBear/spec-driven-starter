#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# setup.sh — One-command scaffold for a new spec-driven project
#
# Run AFTER:
#   1. Cloning this repo
#   2. Filling in PROJECT_SPEC.md
#
# What this does:
#   - Creates the Next.js app scaffold (tsconfig, app dir, etc.)
#   - Creates Prisma schema, Jest config, Playwright config
#   - Copies .env.example → .env.local
#   - Runs npm install
# ============================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo ""
echo "======================================"
echo "  Next.js App Scaffold"
echo "======================================"

if [[ -d "src" ]]; then
  echo "! src/ already exists — scaffold already run"
  echo "  Run 'npm install' manually if needed"
  exit 0
fi

# ── Directories ───────────────────────────────────────────────
mkdir -p \
  src/app/api/auth/\[...all\] \
  src/lib \
  src/components \
  prisma/seed \
  tests/e2e

echo "✓ Directory structure created"

# ── tsconfig.json ─────────────────────────────────────────────
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
echo "✓ tsconfig.json"

# ── next.config.ts ────────────────────────────────────────────
cat > next.config.ts << 'EOF'
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {}

export default nextConfig
EOF
echo "✓ next.config.ts"

# ── postcss.config.mjs (Tailwind v4) ──────────────────────────
cat > postcss.config.mjs << 'EOF'
const config = {
  plugins: {
    '@tailwindcss/postcss': {},
  },
}
export default config
EOF
echo "✓ postcss.config.mjs"

# ── ESLint flat config (ESLint 9) ──────────────────────────────
cat > eslint.config.mjs << 'EOF'
import { dirname } from 'path'
import { fileURLToPath } from 'url'
import { FlatCompat } from '@eslint/eslintrc'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

const compat = new FlatCompat({ baseDirectory: __dirname })

const eslintConfig = [
  ...compat.extends('next/core-web-vitals', 'next/typescript'),
]

export default eslintConfig
EOF
echo "✓ eslint.config.mjs"

# ── src/app/globals.css ───────────────────────────────────────
cat > src/app/globals.css << 'EOF'
@import "tailwindcss";
EOF
echo "✓ src/app/globals.css"

# ── src/app/layout.tsx ────────────────────────────────────────
cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'App',
  description: 'Built with spec-driven-starter',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
EOF
echo "✓ src/app/layout.tsx"

# ── src/app/page.tsx ──────────────────────────────────────────
cat > src/app/page.tsx << 'EOF'
export default function Home() {
  return (
    <main className="min-h-screen p-8">
      <h1 className="text-2xl font-bold">Getting started</h1>
      <p className="mt-4 text-gray-600">
        Fill in <code>PROJECT_SPEC.md</code> and start building with Claude.
      </p>
    </main>
  )
}
EOF
echo "✓ src/app/page.tsx"

# ── Better Auth route handler ─────────────────────────────────
cat > "src/app/api/auth/[...all]/route.ts" << 'EOF'
import { auth } from '@/lib/auth'
import { toNextJsHandler } from 'better-auth/next-js'

export const { GET, POST } = toNextJsHandler(auth)
EOF
echo "✓ src/app/api/auth/[...all]/route.ts"

# ── src/lib/db.ts ─────────────────────────────────────────────
cat > src/lib/db.ts << 'EOF'
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
EOF
echo "✓ src/lib/db.ts"

# ── src/lib/auth.ts (Better Auth) ────────────────────────────
cat > src/lib/auth.ts << 'EOF'
import { betterAuth } from 'better-auth'
import { prismaAdapter } from 'better-auth/adapters/prisma'
import { prisma } from './db'

export const auth = betterAuth({
  database: prismaAdapter(prisma, {
    provider: 'postgresql',
  }),
  emailAndPassword: {
    enabled: true,
  },
  // Uncomment and configure social providers as needed (see PROJECT_SPEC.md):
  // socialProviders: {
  //   github: {
  //     clientId: process.env.GITHUB_CLIENT_ID!,
  //     clientSecret: process.env.GITHUB_CLIENT_SECRET!,
  //   },
  //   google: {
  //     clientId: process.env.GOOGLE_CLIENT_ID!,
  //     clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
  //   },
  // },
})
EOF
echo "✓ src/lib/auth.ts"

# ── src/lib/auth-client.ts (Better Auth) ─────────────────────
cat > src/lib/auth-client.ts << 'EOF'
import { createAuthClient } from 'better-auth/react'

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_APP_URL,
})

export const { signIn, signOut, signUp, useSession } = authClient
EOF
echo "✓ src/lib/auth-client.ts"

# ── src/middleware.ts ─────────────────────────────────────────
cat > src/middleware.ts << 'EOF'
import { getSessionCookie } from 'better-auth/cookies'
import { NextRequest, NextResponse } from 'next/server'

export function middleware(request: NextRequest) {
  const sessionCookie = getSessionCookie(request)

  // Redirect to /sign-in if no session cookie found.
  // Always re-validate the full session inside protected Server Components.
  if (!sessionCookie) {
    return NextResponse.redirect(new URL('/sign-in', request.url))
  }

  return NextResponse.next()
}

export const config = {
  // Protect these routes — adjust to match your app's protected paths:
  matcher: ['/dashboard/:path*', '/settings/:path*'],
}
EOF
echo "✓ src/middleware.ts"

# ── prisma/schema.prisma ──────────────────────────────────────
cat > prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// ── Better Auth models ────────────────────────────────────────
// Generated by: npx @better-auth/cli generate
// Do not modify these manually unless you know what you are doing.

model User {
  id            String    @id @default(cuid())
  name          String
  email         String    @unique
  emailVerified Boolean   @default(false)
  image         String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  sessions      Session[]
  accounts      Account[]

  @@map("user")
}

model Session {
  id        String   @id @default(cuid())
  expiresAt DateTime
  token     String   @unique
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  ipAddress String?
  userAgent String?
  userId    String
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("session")
}

model Account {
  id                    String    @id @default(cuid())
  accountId             String
  providerId            String
  userId                String
  accessToken           String?
  refreshToken          String?
  idToken               String?
  accessTokenExpiresAt  DateTime?
  refreshTokenExpiresAt DateTime?
  scope                 String?
  password              String?
  createdAt             DateTime  @default(now())
  updatedAt             DateTime  @updatedAt
  user                  User      @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("account")
}

model Verification {
  id         String   @id @default(cuid())
  identifier String
  value      String
  expiresAt  DateTime
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt

  @@map("verification")
}

// ── App models ────────────────────────────────────────────────
// Add your app-specific models below.
// Claude will scaffold these from PROJECT_SPEC.md.
EOF
echo "✓ prisma/schema.prisma"

# ── prisma/seed/seed.ts ───────────────────────────────────────
cat > prisma/seed/seed.ts << 'EOF'
import { prisma } from '../../src/lib/db'

async function main() {
  console.log('Seeding...')
  // Add seed data here
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect())
EOF
echo "✓ prisma/seed/seed.ts"

# ── jest.config.ts ────────────────────────────────────────────
cat > jest.config.ts << 'EOF'
import type { Config } from 'jest'
import nextJest from 'next/jest.js'

const createJestConfig = nextJest({ dir: './' })

const config: Config = {
  coverageProvider: 'v8',
  testEnvironment: 'jsdom',
  setupFilesAfterFramework: ['<rootDir>/jest.setup.ts'],
}

export default createJestConfig(config)
EOF
echo "✓ jest.config.ts"

# ── jest.setup.ts ─────────────────────────────────────────────
cat > jest.setup.ts << 'EOF'
import '@testing-library/jest-dom'
EOF
echo "✓ jest.setup.ts"

# ── playwright.config.ts ──────────────────────────────────────
cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
EOF
echo "✓ playwright.config.ts"

# ── tests/e2e placeholder ─────────────────────────────────────
touch tests/e2e/.gitkeep
echo "✓ tests/e2e/"

# ── .env.local ────────────────────────────────────────────────
if [[ ! -f ".env.local" ]]; then
  if [[ -f ".env.example" ]]; then
    cp .env.example .env.local
    echo "✓ .env.local created from .env.example — fill in your values"
  else
    echo "! No .env.example found — create .env.local manually"
  fi
else
  echo "✓ .env.local already exists"
fi

# ── npm install ───────────────────────────────────────────────
echo ""
echo "Running npm install..."
npm install

echo ""
echo "======================================"
echo "  Setup complete!"
echo "======================================"
echo ""
echo "NEXT STEPS:"
echo "  1. Edit .env.local — set DATABASE_URL and BETTER_AUTH_SECRET"
echo "     Generate BETTER_AUTH_SECRET: openssl rand -base64 32"
echo ""
echo "  2. Start your database:"
echo "     npm run db:start"
echo ""
echo "  3. Push Prisma schema:"
echo "     npm run db:push"
echo ""
echo "  4. Open in Claude Code:"
echo "     claude"
echo ""
echo "  Claude will read PROJECT_SPEC.md and start building."
echo ""
