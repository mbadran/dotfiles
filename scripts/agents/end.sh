#!/usr/bin/env bash
# dotfiles session wrapup
# Run after Claude has updated PRD.md, memory files, and any docs.

unalias -a 2>/dev/null || true
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"

echo "══ session commits (today) ═════════════════════════════════════"
git log --oneline --since="midnight" 2>/dev/null || true
if [ -z "$(git log --oneline --since="midnight" 2>/dev/null)" ]; then
  echo "(no commits today)"
fi

echo ""
echo "══ open tasks (phase 3) ════════════════════════════════════════"
grep -E "^\s*- \[ \]" PRD.md | head -20 || echo "(none found)"

echo ""
echo "══ final drift check ═══════════════════════════════════════════"
brew bundle check --verbose 2>&1 || true

echo ""
echo "══ git status ══════════════════════════════════════════════════"
git status --short

echo ""
echo "══ uncommitted changes ═════════════════════════════════════════"
git diff --stat 2>/dev/null || true

echo ""
echo "══ permissions (current allow list) ════════════════════════════"
python3 -c "
import json
with open('.claude/settings.json') as f:
    s = json.load(f)
for entry in s.get('permissions', {}).get('allow', []):
    print(' ', entry)
" 2>/dev/null || echo "(could not read settings.json)"

echo ""
echo "⚠  reminder: push manually if ready (git push)"
echo ""
echo "Sayonara, Mo san."
