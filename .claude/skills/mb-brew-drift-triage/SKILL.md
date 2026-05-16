---
name: mb-brew-drift-triage
description: Use when `scripts/brew/sync.py` has appended one or more items to the `uncategorized` section of the Brewfile and the user wants them triaged. Also use when the user says "triage drift" or "what about the new brew items" or asks why something landed in uncategorized. The output is one decision per item — keep+categorize, remove, or leave with a note — backed by `brew info` / `brew uses` / install-time evidence.
---

# mb-brew-drift-triage

## Overview

`scripts/brew/sync.py` is conservative: when it sees a formula or cask installed but not in the Brewfile, it appends it to an `uncategorized` section with the `brew info` description rather than dropping it. Triaging that section is a manual step that needs investigation per item.

This skill is the checklist + commands for that investigation.

## When to use

- Just after `start.sh` runs and the brew sync has landed new items
- User says "triage the uncategorized section" or "what's that new brew item"
- Before a commit that touches the Brewfile, if `uncategorized` is non-empty

## When NOT to use

- The Brewfile is clean — nothing in `uncategorized`. Skip.
- The user has already decided about each item — just commit. Skip.

## The three outcomes per item

| Outcome | Means | Action |
| ------- | ----- | ------ |
| **Categorize** | Item is something Mo intentionally installed and uses | Move from `uncategorized` to the appropriate section in the Brewfile, keep the description |
| **Remove**     | Item was a transitive install or one-off experiment | Delete from Brewfile + `brew uninstall <name>` (ask user before uninstalling) |
| **Comment**    | Item is special: third-party tap, Mac-only quirk, or deliberate exclusion | Move with a comment explaining why; or keep in `uncategorized` with a `#` note appended |

## Investigation commands (per item)

For each item in `uncategorized`, gather facts before deciding:

```bash
# 1. What does it do? (one-line description, dependencies, version)
brew info <name>

# 2. Was it installed manually or as a dependency? If manual, it was a deliberate choice.
brew list --installed-on-request | grep -x <name>

# 3. What else depends on it? If something else needs it, removing breaks that.
brew uses --installed <name>

# 4. When was it installed? (file stat on the cellar dir)
stat -f '%Sm' "$(brew --prefix)/Cellar/<name>" 2>/dev/null || \
  stat -f '%Sm' "$(brew --prefix)/Caskroom/<name>"

# 5. What tap is it from? Third-party taps deserve a comment.
brew info <name> --json | jq -r '.formulae[0].tap // .casks[0].tap'
```

## Decision tree

```
Was it installed-on-request (manual)?
├── Yes → likely a Mo choice
│   ├── Has anything used it (uses-installed non-empty)?
│   │   ├── Yes → CATEGORIZE under appropriate section
│   │   └── No  → Ask Mo: still using it? If yes CATEGORIZE; if no REMOVE
│   └── Third-party tap?
│       └── COMMENT with the tap source
└── No  → transitive dependency
    └── Don't add to Brewfile at all; will be re-pulled by parent
        REMOVE the uncategorized line (parent install will re-fetch)
```

## Brewfile section conventions

Existing categorized sections in `.config/brew/Brewfile` group items by purpose. Match the new item to the closest section by intent, not alphabetical:

- Look at the existing section headers in the Brewfile (`grep '^# ===' Brewfile` or similar)
- If nothing fits, leave in `uncategorized` with a `#` note — *don't invent a new section* without asking the user

## Output format

When triaging, report per-item using this shape:

```
- <name>: <CATEGORIZE|REMOVE|COMMENT> — <one-line reason>
  - info: <short description>
  - installed-on-request: yes/no
  - used by: <list or "nothing">
  - tap: <core | third-party-name>
```

Then summarize at the end:
- N items to categorize (proposed sections)
- N items to remove (with caveat: ask before uninstalling)
- N items to leave with comment

## Common mistakes

- Auto-removing items that are installed-on-request — those represent deliberate choices; check with Mo
- Inventing new Brewfile sections to fit one-off items — prefer comments or `uncategorized` with a note
- Running `brew uninstall` without asking — destructive, needs explicit user confirmation per `~/.claude/AGENTS.md` paranoia rules
- Categorizing without checking `brew uses --installed` — if something depends on it, the section it lives in implies "needed by X"; pick wisely
