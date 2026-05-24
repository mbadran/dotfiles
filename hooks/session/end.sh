#!/usr/bin/env bash
# dotfiles session wrapup — invoked by the global SessionEnd hook.
# Project-specific extras only — drift/push reminder/signoff live in the global hook.

unalias -a 2>/dev/null || true
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"

echo "══ brew final drift check ══════════════════════════════════════"
brew bundle check --verbose 2>&1 || true

echo ""
echo "══ open PRD tasks ══════════════════════════════════════════════"
grep -E "^\s*- \[ \]" PRD.md | head -20 || echo "(none)"

echo ""
echo "══ uncommitted diff stat ═══════════════════════════════════════"
git diff --stat 2>/dev/null || true
