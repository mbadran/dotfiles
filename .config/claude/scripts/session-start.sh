#!/usr/bin/env bash
# Global Claude Code SessionStart hook — runs for every project.
# Stays under 3s. Output goes into Claude's context as additional info.
#
# Phases:
#   1. project recap   — git branch, last 3 commits, drift count
#   2. memory bootstrap — surface project memory (count + recent files)
#   3. memory hygiene   — flag memory files older than 30 days as decay candidates
#   4. local routine    — invoke <repo>/scripts/agents/start.sh if executable
#
# Notes:
#   - $CLAUDE_PROJECT_DIR is set by Claude Code; falls back to pwd.
#   - Failures must not break the session — every command ends with `|| true`.

set -u
cwd="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$cwd" 2>/dev/null || exit 0

echo "═════ session start: $(basename "$cwd") @ $(date +'%Y-%m-%d %H:%M') ═════"

# 1. project recap (git only — silent for non-repos)
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo '(detached)')
    drift=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    echo
    echo "── git ──"
    echo "branch: $branch  |  uncommitted entries: $drift"
    echo "recent:"
    git -C "$cwd" log -3 --oneline 2>/dev/null | sed 's/^/  /' || true
fi

# 2 + 3. memory bootstrap and hygiene
# Claude Code stores per-project memory under ~/.claude/projects/<encoded>/memory/
# The encoding is the project path with `/` replaced by `-` (and a leading `-`).
encoded="-$(echo "$cwd" | sed 's|/|-|g' | sed 's|^-||')"
mem_dir="$HOME/.claude/projects/${encoded}/memory"

if [ -d "$mem_dir" ]; then
    mem_count=$(find "$mem_dir" -maxdepth 1 -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
    echo
    echo "── memory ──"
    echo "files: $mem_count  |  dir: ${mem_dir/#$HOME/~}"
    if [ "$mem_count" -gt 0 ]; then
        echo "recent:"
        find "$mem_dir" -maxdepth 1 -name '*.md' -type f -exec stat -f '%m %N' {} \; 2>/dev/null \
            | sort -rn | head -3 | awk '{ $1=""; sub(/^ /,""); print "  " $0 }' \
            | sed "s|$mem_dir/||" || true

        # decay candidates: files not modified in 30+ days
        decay=$(find "$mem_dir" -maxdepth 1 -name '*.md' -type f -mtime +30 2>/dev/null | wc -l | tr -d ' ')
        if [ "$decay" -gt 0 ]; then
            echo "decay candidates (30+ days): $decay file(s) — review and prune at session end"
        fi
    fi
fi

# 4. project-local start routine (only if present and executable)
if [ -x "$cwd/scripts/agents/start.sh" ]; then
    echo
    echo "── project: scripts/agents/start.sh ──"
    bash "$cwd/scripts/agents/start.sh" 2>&1 || true
fi

echo
echo "═════════════════════════════════════════════════════"
exit 0
