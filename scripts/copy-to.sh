#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# copy-to.sh — Copy this starter's Claude system into a project
#
# Usage:
#   bash scripts/copy-to.sh /path/to/my-next-app
# ============================================================

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "Usage: bash scripts/copy-to.sh /path/to/your-project"
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "Error: '$TARGET' is not a directory"
  exit 1
fi

STARTER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Copying starter files to: $TARGET"
echo ""

# .claude system
cp -r "$STARTER_ROOT/.claude" "$TARGET/"
echo "✓ .claude/"

# CLAUDE.md
cp "$STARTER_ROOT/CLAUDE.md" "$TARGET/"
echo "✓ CLAUDE.md"

# PROJECT_SPEC.md (only if not already present)
if [[ ! -f "$TARGET/PROJECT_SPEC.md" ]]; then
  cp "$STARTER_ROOT/PROJECT_SPEC.md" "$TARGET/"
  echo "✓ PROJECT_SPEC.md"
else
  echo "  PROJECT_SPEC.md already exists — skipping"
fi

# .env.example (only if not already present)
if [[ ! -f "$TARGET/.env.example" ]]; then
  cp "$STARTER_ROOT/.env.example" "$TARGET/"
  echo "✓ .env.example"
else
  echo "  .env.example already exists — skipping"
fi

# scripts/
mkdir -p "$TARGET/scripts"
cp "$STARTER_ROOT/scripts/bootstrap.sh" "$TARGET/scripts/"
cp "$STARTER_ROOT/scripts/check-versions.sh" "$TARGET/scripts/"
chmod +x "$TARGET/scripts/bootstrap.sh"
chmod +x "$TARGET/scripts/check-versions.sh"
echo "✓ scripts/bootstrap.sh"
echo "✓ scripts/check-versions.sh"

echo ""
echo "Done. Next steps:"
echo "  1. cd $TARGET"
echo "  2. Merge dependencies from spec-driven-starter/package.json into your package.json"
echo "  3. npm install"
echo "  4. Fill in PROJECT_SPEC.md"
echo "  5. bash scripts/bootstrap.sh"
