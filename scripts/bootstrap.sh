#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# bootstrap.sh — Post-install setup for a new project
#
# Run AFTER:
#   1. Cloning this repo
#   2. Filling in PROJECT_SPEC.md
#   3. Running: npm install
#
# What this does:
#   - Copies .env.example → .env.local (if not already present)
#   - Creates prisma/seed directory
#   - Runs prisma generate (requires DATABASE_URL in .env.local)
#   - Installs Playwright browsers
# ============================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo ""
echo "======================================"
echo "  Project setup"
echo "======================================"

# .env.local
if [[ ! -f ".env.local" ]]; then
  if [[ -f ".env.example" ]]; then
    cp .env.example .env.local
    echo "✓ Created .env.local from .env.example — fill in your values"
  else
    echo "! No .env.example found — create .env.local manually"
  fi
else
  echo "✓ .env.local already exists"
fi

# Prisma dirs
mkdir -p prisma/seed
echo "✓ prisma/seed directory ready"

# Prisma generate (only if DATABASE_URL is set)
if grep -q "DATABASE_URL" .env.local 2>/dev/null && \
   ! grep -q "DATABASE_URL=your_" .env.local 2>/dev/null; then
  echo "Running prisma generate..."
  npx prisma generate || echo "! prisma generate failed — check DATABASE_URL in .env.local"
else
  echo "! DATABASE_URL not set — skipping prisma generate (run 'npm run db:generate' after setting it)"
fi

# Playwright
echo "Installing Playwright browsers (chromium only)..."
npx playwright install chromium --with-deps 2>/dev/null || \
  echo "! Playwright install skipped — run 'npx playwright install chromium' manually"

echo ""
echo "======================================"
echo "  Setup complete"
echo "======================================"
echo ""
echo "NEXT STEPS:"
echo "  1. Edit .env.local with your database URL and auth secrets"
echo "  2. Start your database:   npm run db:start"
echo "  3. Push schema:           npm run db:push"
echo "  4. Seed database:         npm run db:seed"
echo "  5. Start dev server:      npm run dev"
echo ""
echo "In Claude Code:"
echo "  - Open PROJECT_SPEC.md and fill in your project requirements"
echo "  - Run /specify to generate your first feature spec"
echo ""
