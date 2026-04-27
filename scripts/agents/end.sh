#!/usr/bin/env bash
# dotfiles session wrapup
# Run after Claude has updated PRD.md, memory files, and any docs.

unalias -a 2>/dev/null || true
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"

echo "══ final drift check ═══════════════════════════════════════════"
brew bundle check --verbose 2>&1 || true

echo ""
echo "══ git status ══════════════════════════════════════════════════"
git status --short

echo ""
echo "══ uncommitted changes ═════════════════════════════════════════"
git diff --stat 2>/dev/null || true

echo ""
echo "Sayonara Mo san."
