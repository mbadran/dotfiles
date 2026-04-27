#!/usr/bin/env bash
# dotfiles session startup
# Run at the start of every Claude session.
# Prints everything Claude needs for the start checklist — no separate Read calls required.

unalias -a 2>/dev/null || true
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
MEMORY_DIR="$HOME/.claude/projects/-Users-mb-Documents-projects-dotfiles/memory"

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

echo ""
echo "══ memory files ════════════════════════════════════════════════"
if [ -f "$MEMORY_DIR/MEMORY.md" ]; then
  for mdfile in $(grep -oE '\([^)]+\.md\)' "$MEMORY_DIR/MEMORY.md" | tr -d '()'); do
    fpath="$MEMORY_DIR/$mdfile"
    if [ -f "$fpath" ]; then
      echo ""
      echo "── $mdfile ──"
      cat "$fpath"
    fi
  done
else
  echo "(MEMORY.md not found)"
fi

echo ""
echo "══ open PRD tasks ══════════════════════════════════════════════"
grep -n "^\s*- \[ \]" PRD.md | head -30 || echo "(none)"

echo ""
echo "══ nvim keymaps ════════════════════════════════════════════════"
bash "$REPO/scripts/nvim/keymaps.sh"

echo ""
echo "══ permissions (allow list) ════════════════════════════════════"
python3 -c "
import json
with open('.claude/settings.json') as f:
    s = json.load(f)
for entry in s.get('permissions', {}).get('allow', []):
    print(' ', entry)
" 2>/dev/null || echo "(could not read settings.json)"
