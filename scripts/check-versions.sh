#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# check-versions.sh — Report available package updates
#
# Runs npm-check-updates to show what's outdated, grouped by
# update type (patch, minor, major). Major updates are flagged
# as potentially breaking.
#
# Usage:
#   ./scripts/check-versions.sh           # report only
#   ./scripts/check-versions.sh --upgrade # update package.json + install
#
# Or via npm:
#   npm run check-versions
#   npm run check-versions:upgrade
# ============================================================

UPGRADE=false
if [[ "${1:-}" == "--upgrade" ]]; then
  UPGRADE=true
fi

echo ""
echo "Checking for package updates..."
echo ""

if [[ "$UPGRADE" == "true" ]]; then
  echo "MODE: update package.json and install"
  echo ""
  npx --yes npm-check-updates --format group -u
  npm install
  echo ""
  echo "Done. Run 'npm run build' to verify nothing broke."
else
  npx --yes npm-check-updates --format group
  echo ""
  echo "To apply all updates: ./scripts/check-versions.sh --upgrade"
  echo "  (or: npm run check-versions:upgrade)"
  echo ""
  echo "CAUTION — before upgrading majors:"
  echo "  - Check changelogs for breaking changes"
  echo "  - Prisma major: requires schema migration + adapter review"
  echo "  - next-auth v4→v5: full rewrite (Auth.js), not backwards-compatible"
  echo "  - Tailwind v4 is already installed (v3→v4 is a breaking change)"
  echo "  - eslint v9 is already installed (v8→v9 config format changed)"
  echo ""
fi
