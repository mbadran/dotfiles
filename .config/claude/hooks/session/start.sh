#!/usr/bin/env bash
# Global Claude Code SessionStart hook — runs for every project.
# Stays under 3s. Output goes into Claude's context as additional info.
#
# Phases:
#   1. project recap     — git branch, last 3 commits, drift count
#   2. memory bootstrap  — surface project memory (count + recent files)
#   3. memory hygiene    — flag memory files older than 30 days as decay candidates
#   4. memory content    — dump full contents of files listed in MEMORY.md
#   5. open tasks        — PRD/roadmap unchecked items + open GitHub issues (where available)
#   6. todo/fixme scan   — scan cwd for outstanding markers
#   7. local routine     — invoke <repo>/hooks/session/start.sh if executable
#   8. permissions list  — print project .claude/settings.json allow entries
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

    # 4. memory content dump — read everything listed in MEMORY.md
    if [ -f "$mem_dir/MEMORY.md" ]; then
        echo
        echo "── memory content ──"
        for mdfile in $(grep -oE '\([^)]+\.md\)' "$mem_dir/MEMORY.md" | tr -d '()'); do
            fpath="$mem_dir/$mdfile"
            if [ -f "$fpath" ]; then
                echo
                echo "── $mdfile ──"
                cat "$fpath"
            fi
        done
    fi
fi

# 5. open tasks — PRD/roadmap unchecked items + open GitHub issues (generic across repos)
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    task_doc=""
    for cand in PRD.md ROADMAP.md TODO.md docs/PRD.md docs/ROADMAP.md; do
        [ -f "$cwd/$cand" ] && { task_doc="$cwd/$cand"; break; }
    done
    open_tasks=""
    [ -n "$task_doc" ] && open_tasks=$(grep -nE '^[[:space:]]*- \[ \]' "$task_doc" 2>/dev/null | head -15)
    gh_issues=""
    if command -v gh >/dev/null 2>&1; then
        gh_issues=$(cd "$cwd" && gh issue list --state open --limit 8 2>/dev/null || true)
    fi
    if [ -n "$open_tasks" ] || [ -n "$gh_issues" ]; then
        echo
        echo "── open tasks ──"
        if [ -n "$open_tasks" ]; then
            echo "unchecked in ${task_doc/#$cwd\//}:"
            echo "$open_tasks" | sed 's/^/  /'
        fi
        if [ -n "$gh_issues" ]; then
            echo "open GitHub issues (top 8):"
            echo "$gh_issues" | sed 's/^/  /'
        fi
    fi
fi

# 6. todo/fixme scan (only in git repos; common source extensions)
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo
    echo "── todo/fixme ──"
    todo_out=$(grep -rn "TODO\|FIXME" \
        --include="*.lua" --include="*.toml" --include="*.zsh" \
        --include="*.conf" --include="*.env" --include="*.md" \
        --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
        --include="*.py" --include="*.rs" --include="*.sh" \
        --exclude-dir=".git" --exclude-dir="node_modules" \
        --exclude-dir="working" --exclude-dir="scripts" \
        --exclude-dir="raycast" --exclude-dir=".worktrees" \
        "$cwd" 2>/dev/null | head -20)
    if [ -n "$todo_out" ]; then
        echo "$todo_out" | sed "s|^$cwd/||"
    else
        echo "(none)"
    fi
fi

# 7. project-local start routine — runs AFTER the global phases above.
#    Convention: <repo>/hooks/session/start.sh (only if present and executable).
if [ -x "$cwd/hooks/session/start.sh" ]; then
    echo
    echo "── project: hooks/session/start.sh ──"
    bash "$cwd/hooks/session/start.sh" 2>&1 || true
fi

# 8. project permissions allow list
if [ -f "$cwd/.claude/settings.json" ]; then
    echo
    echo "── permissions (allow list) ──"
    python3 -c "
import json
try:
    with open('$cwd/.claude/settings.json') as f:
        s = json.load(f)
    for entry in s.get('permissions', {}).get('allow', []):
        print(' ', entry)
except Exception as e:
    print(f'(could not read settings.json: {e})')
" 2>/dev/null || true
fi

echo
echo "═════════════════════════════════════════════════════"
exit 0
