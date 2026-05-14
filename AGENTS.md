# dotfiles project — agent instructions

## Session start

**Before responding to anything — including "go", "resume", or a task request — complete this checklist and output the table:**

| #  | Task                                                                          | Source    |
|----|-------------------------------------------------------------------------------|-----------|
| 1  | `bash scripts/hooks/session/start.sh`                                         | start.sh  |
| 2  | Verify start.sh output (brew, TODOs, git, memory, open tasks, permissions)    | AGENTS.md |
| 3  | Present project state summary: phase, open tasks, parked items, any drift     | AGENTS.md |

> `start.sh` now prints memory files, open PRD tasks, and the permissions allow list — no separate Read calls needed.

## Session end

When the user says "let's wrap up" (or similar), complete this checklist and output the table:

| #  | Task                                                                                    | Source             |
|----|-----------------------------------------------------------------------------------------|--------------------|
| 1  | Update PRD.md — tick completed tasks, note parked decisions                             | AGENTS.md          |
| 2  | Update TESTING.md — add checklists for any new configs                                  | AGENTS.md          |
| 3  | Update `memory/project_dotfiles_state.md`                                               | AGENTS.md          |
| 4  | Review `.claude/settings.json` for any new approval gaps                                | AGENTS.md + end.sh |
| 5  | `bash scripts/hooks/session/end.sh` — session commits, open tasks, drift, push reminder | end.sh             |
| 6  | Sign off — "Sayonara, Mo San."                                                          | AGENTS.md          |

> **On hooks:** `SessionStart` and `SessionEnd` are wired in `~/.claude/settings.json` to run `~/.config/claude/hooks/session/{start,end}.sh`. Those global hooks invoke this repo's `scripts/hooks/session/{start,end}.sh` if executable. The "type wrap up so Claude runs the end checklist" pattern remains — the hook does mechanical drift summary, but the LLM-side recap (what was done, what's next) still needs the user to signal end-of-session.

## Shell alias workarounds

`.zshrc` aliases several commands to interactive or replacement versions. Each Bash tool call spawns a fresh shell that re-sources `.zshrc`, so aliases cannot be cleared once globally.

**Rule: begin every Bash tool call that touches aliased commands with:**
```bash
unalias -a 2>/dev/null; <rest of command>
```

This clears all aliases for that call. The scripts in `scripts/hooks/session/` already do this. Prefer the Grep and Glob tools over `grep`/`find` — they bypass the shell entirely.

## Workflow

- Manage tasks and focus within PRD.md; update it after relevant changes
- Update all key files in the table at the bottom of this file after relevant changes
- Keep `.gitignore` and `non-brew-apps.md` current
- One config = one commit
- `working/` is a gitignored scratchpad for experiments and test fixtures only — no long-term docs or instructions; anything that needs to persist goes in a tracked file

## Commit style

When about to `git commit` in this repo, load the `committing-dotfiles-mo` skill from `.claude/skills/` — covers message style, scope, pre-commit hygiene, and push restraint.

## Editing style

See `~/.claude/AGENTS.md` "Editing discipline" — those rules apply universally and aren't dotfiles-specific.

## Tables

When writing or editing any Markdown table, load the `formatting-mo` skill (user-wide) — covers table alignment, section header style, prose wrap, and trailing whitespace.

## Drift management

Check for config and package drift at session start and at each phase polish step.

**Config drift:**
Check project root and `.config/` for untracked dirs. If new configs exist that are neither tracked nor referenced in `non-brew-apps.md`, either track them or add with a note to that file and `.gitignore`. If tracked configs are absent on the system, install them or remove their references.

**Brew drift — automated.** `scripts/brew/sync.py` runs from `start.sh` every session and keeps the Brewfile mirroring `brew leaves` ∪ `brew list --cask`:

- Forward drift (manually installed → not in Brewfile): appended to an `uncategorized` section at the bottom, with the description from `brew info`. Recategorise manually when convenient.
- Reverse drift (in Brewfile → no longer installed): the line is removed, gated by the host-local state file `.config/brew/.installed.lock` so a fresh-clone machine doesn't get its Brewfile wiped before first `brew bundle install`.
- Tap entries for new tap-prefixed formulae are auto-added; existing tap lines are never auto-removed.
- Lines commented out (e.g. `# cask "ovim"`) are treated as deliberate exclusions and left alone in either direction.

`start.sh` runs `brew bundle install` first (no-op when in sync, populates fresh machines), then `sync.py` to capture any post-install drift.

For ad-hoc inspection:
```
brew leaves --installed-on-request   # all manually installed formulae
brew list --cask                     # all installed casks
```

## Phase polish checklist

At the polish step of every phase:

- **Drift** — run drift check, update Brewfile and `.gitignore` as needed
- **TODO/FIXME** — scan and triage (see below)
- **Claude permissions** — review `.claude/settings.json` for approval gaps (see below)
- **Docs** — update README.md stats, TESTING.md checklists, PRD.md task statuses

## TODO/FIXME hygiene

Scan tracked files for `TODO` and `FIXME` at each phase polish step:

```
rg "TODO|FIXME" --glob "*.{md,lua,toml,zsh,conf,json,sh,env}" -n
```

- Every `TODO`: resolve, convert to a PRD task, or keep with a deliberate note
- Every `FIXME`: file as a bug task in PRD.md
- No loose/unresolved comments in committed files

## Claude permissions review

At each phase polish step, review `.claude/settings.json` for gaps:
- Any command that prompted for approval during the phase should be added to `allow` with a wildcard
- Goal: zero approval prompts for read-only and routine operations
- Keep `ask` for destructive operations (push, force reset, rm)

## Starship toml

When editing `.config/starship.toml` — especially the `format` / `right_format` blocks — load the `starship-powerline-glyph-edit` skill from `.claude/skills/`.

## Key files

| File                            | Role                                                                      |
| ------------------------------- | ------------------------------------------------------------------------- |
| `.claude/settings.json`         | Project Claude Code permissions — review each phase                       |
| `.config/brew/Brewfile`         | Package manifest — maintain descriptions/sections                         |
| `.config/brew/README.md`        | Brew package overview — update when Brewfile changes                      |
| `.config/brew/brew.env`         | Homebrew env vars (HOMEBREW_BUNDLE_FILE etc.)                             |
| `.config/brew/non-brew-apps.md` | Apps not managed by brew                                                  |
| `.config/claude/hooks/session/` | Global SessionStart/End hook scripts (run for every project)              |
| `.config/claude/settings.json`  | User-global Claude Code config (symlinked from `~/.claude/settings.json`) |
| `.config/ghostty/config`        | Ghostty terminal config                                                   |
| `.config/git/config`            | Global git config (XDG — credential helper, user identity)                |
| `.config/git/ignore`            | Global gitignore (XDG default, applies to all repos)                      |
| `.config/nvim/init.lua`         | Neovim config — plugins, mappings, options                                |
| `.config/page/init.lua`         | Neovim-based pager config                                                 |
| `.config/starship.toml`         | Starship prompt — use Python for edits with PUA glyphs                    |
| `.config/zsh/.zprofile`         | Login shell config (symlinked from `~/.zprofile`)                         |
| `.config/zsh/.zshrc`            | Interactive shell config (symlinked from `~/.zshrc`)                      |
| `.gitignore`                    | Per-repo gitignore — keep current                                         |
| `AGENTS.md`                     | This file — agent instructions (single source of truth)                   |
| `CLAUDE.md`                     | Thin pointer to AGENTS.md for Claude Code                                 |
| `PRD.md`                        | Living roadmap — update after relevant changes                            |
| `README.md`                     | Project overview — update stats after changes                             |
| `TESTING.md`                    | Verification checklists — update after changes                            |
| `memory/MEMORY.md`              | Memory index — read at session start                                      |
| `scripts/hooks/session/end.sh`         | Session wrapup — run after docs updated, prints final status              |
| `scripts/hooks/session/start.sh`       | Session startup — run at session start, outputs drift/state               |
