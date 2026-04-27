#!/usr/bin/env bash
# dotfiles session startup
# Run at the start of every Claude session. Claude reads this output, then
# separately reads memory files and PRD.md before presenting project state.

unalias -a 2>/dev/null || true
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"

echo "══ brew drift ══════════════════════════════════════════════════"
brew bundle check --verbose 2>&1 || true

echo ""
echo "══ config scan ═════════════════════════════════════════════════"
ls ~/.config/

echo ""
echo "══ TODO/FIXME scan ═════════════════════════════════════════════"
grep -rn "TODO\|FIXME" \
  --include="*.lua" --include="*.toml" \
  --include="*.zsh" --include="*.conf" --include="*.env" \
  --exclude-dir=".git" --exclude-dir="working" --exclude-dir="scripts" \
  --exclude-dir="raycast" \
  . 2>/dev/null || echo "(none)"

echo ""
echo "══ git status ══════════════════════════════════════════════════"
git status --short
