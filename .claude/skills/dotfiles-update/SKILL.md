---
name: dotfiles-update
description: Use when wrapping up a change in the dotfiles repo, after any tool swap (e.g. tmux to zellij, kitty to ghostty), when README stats may have drifted (plugin/formulae/alias counts), or before any commit that affects user-visible behavior. Symptoms include forgetting README.md, leaving a removed tool referenced in docs, or stale `$TERMINAL`/`$SHELL`/`$EDITOR` claims.
---

# dotfiles-update

## Overview

After any material change in the dotfiles repo, multiple tracked files may need updates. **README.md is the file most often forgotten.** This skill is the explicit sweep checklist — load it whenever you're about to commit a non-trivial change or are at session end.

## When to use

- About to commit a tool swap, config addition, or config removal
- Stats in README.md may have drifted (plugins added/removed, brew formulae changed, aliases tweaked)
- A user-visible claim somewhere (`$TERMINAL`, `$SHELL`, `$EDITOR`, `$PAGER`, etc.) may now be wrong
- At session wrap-up before running `end.sh`

## When NOT to use

- Internal refactor with no behavioral change (just commit)
- Editing a single file that has no cross-references in docs
- Pure typo / comment fix

## The sweep

For each item below, ask "is this still accurate after my change?":

| File | Most common rot | What to check |
|---|---|---|
| `README.md` | tool-swap claims | `$TERMINAL`/`$SHELL`/`$EDITOR`/`$PROMPT`/`$PAGER`/`$TUI`/`$HOMEBREW`/`$AI`/`$LEGACY` blocks |
| `README.md` (stats table) | counts drift | plugin count, vim mappings, formulae, casks, aliases |
| `PRD.md` | unchecked completed tasks | every `[ ]` for items shipped this session |
| `TESTING.md` | missing sections | one section per tracked config |
| `.config/brew/README.md` | drift from Brewfile structure | sections + descriptions match Brewfile |
| `.config/brew/non-brew-apps.md` | manual-install drift | apps installed/removed outside brew |
| `memory/project_dotfiles_state.md` | stale phase % or open issues | reflect what was done this session |
| `AGENTS.md` (key files table, ~line 130) | new file added or retired | add/remove rows |
| `.gitignore` | new artifact types | new generated/cache files |

## Removal vs deprecation

When removing a tool, **leave a justified mention** if any peripheral workflow still relies on it. Example: kitty config was kept in `.config/kitty/` after the ghostty migration because Stream Deck remote-control has no ghostty equivalent (per PRD 3.17). A bare deletion would lose that context.

In TESTING.md and AGENTS.md, prefer a one-line note explaining *why* the residual reference exists.

## Common mistakes

- Updating PRD + memory but forgetting README — README is the user-facing claim sheet; tool swaps almost always rot a README line
- Updating the Brewfile but forgetting `.config/brew/README.md` overview
- Ticking a PRD task without updating `memory/project_dotfiles_state.md` open-issues / phase-complete numbers
- Removing a tool but leaving stale `TESTING.md` sections — either delete the section or annotate why retained

## Quick verify

After the sweep, run:

```bash
git diff --stat
```

If you swapped a tool and only see one file in the diff, the sweep is incomplete.
