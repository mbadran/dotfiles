#!/usr/bin/env bash
# dotfiles session startup — invoked by the global SessionStart hook.
# Project-specific extras only — git/memory/todo/permissions live in the global hook.

unalias -a 2>/dev/null || true
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"

echo "══ brew drift ══════════════════════════════════════════════════"
brew bundle install --quiet 2>&1 | tail -5 || true
echo
python3 "$REPO/scripts/brew/sync.py" 2>&1 || true

echo ""
echo "══ config scan ═════════════════════════════════════════════════"
ls ~/.config/

echo ""
echo "══ open PRD tasks ══════════════════════════════════════════════"
grep -n "^\s*- \[ \]" PRD.md | head -30 || echo "(none)"

echo ""
echo "══ nvim keymaps ════════════════════════════════════════════════"
bash "$REPO/scripts/nvim/keymaps.sh"
