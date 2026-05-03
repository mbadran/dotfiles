#!/usr/bin/env bash
# Global Claude Code SessionEnd hook — runs for every project on session close.
#
# Phases:
#   1. drift summary   — uncommitted file count, push reminder
#   2. local routine   — invoke <repo>/scripts/agents/end.sh if executable
#
# The "what was completed / next steps" recap is done by Claude itself in
# response to the user saying "wrap up" — that needs LLM context, not shell.
# This hook is the shell-side complement: pure mechanical drift + cleanup.

set -u
cwd="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$cwd" 2>/dev/null || exit 0

echo "═════ session end: $(basename "$cwd") @ $(date +'%Y-%m-%d %H:%M') ═════"

# 1. drift summary
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    drift=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    ahead=$(git -C "$cwd" rev-list --count '@{upstream}..HEAD' 2>/dev/null || echo 0)
    echo
    echo "── drift ──"
    echo "uncommitted: $drift  |  unpushed commits: $ahead"
    if [ "$drift" -gt 0 ]; then
        echo "files:"
        git -C "$cwd" status --porcelain 2>/dev/null | sed 's/^/  /' || true
    fi
    if [ "$ahead" -gt 0 ]; then
        echo "reminder: $ahead commit(s) ahead of upstream — push when ready"
    fi
fi

# 2. project-local end routine
if [ -x "$cwd/scripts/agents/end.sh" ]; then
    echo
    echo "── project: scripts/agents/end.sh ──"
    bash "$cwd/scripts/agents/end.sh" 2>&1 || true
fi

echo
echo "═════════════════════════════════════════════════════"
exit 0
