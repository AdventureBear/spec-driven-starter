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
  src/app/api/auth/\[...nextauth\] \
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

# ── NextAuth route handler ────────────────────────────────────
cat > "src/app/api/auth/[...nextauth]/route.ts" << 'EOF'
import NextAuth from 'next-auth'
import { authOptions } from '@/lib/auth'

const handler = NextAuth(authOptions)
export { handler as GET, handler as POST }
EOF
echo "✓ src/app/api/auth/[...nextauth]/route.ts"

# ── src/lib/db.ts ─────────────────────────────────────────────
cat > src/lib/db.ts << 'EOF'
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
EOF
echo "✓ src/lib/db.ts"

# ── src/lib/auth.ts ───────────────────────────────────────────
cat > src/lib/auth.ts << 'EOF'
import { getServerSession } from 'next-auth'
import type { NextAuthOptions } from 'next-auth'

export const authOptions: NextAuthOptions = {
  providers: [
    // Configure providers based on PROJECT_SPEC.md
    // e.g. import GitHub from 'next-auth/providers/github'
  ],
  session: { strategy: 'jwt' },
}

export const getSession = () => getServerSession(authOptions)
EOF
echo "✓ src/lib/auth.ts"

# ── prisma/schema.prisma ──────────────────────────────────────
cat > prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Add models here — Claude will scaffold these from PROJECT_SPEC.md
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
echo "  1. Edit .env.local — set DATABASE_URL and AUTH_SECRET"
echo "     Generate AUTH_SECRET: openssl rand -base64 32"
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
