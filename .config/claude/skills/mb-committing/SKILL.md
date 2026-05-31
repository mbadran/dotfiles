---
name: mb-committing
status: draft
description: Use when about to run `git commit`, drafting a commit message, or staging files in any repo. Covers message format, scope, and push restraint. Exception: in the dotfiles repo, use the local `mb-dotfiles-committing` skill instead.
---

# mb-committing

## Overview

Mo's commit discipline. Default for all repos: **Conventional Commits**. Exception: the dotfiles repo uses its own natural-language style — load `mb-dotfiles-committing` from `.claude/skills/` there instead.

## Default: Conventional Commits

Format: `type(scope): short description`

```
feat(timer): add pause on background
fix(ci): use cy.window().focus() instead of body click
docs(agents): update git workflow — push via git, not push_files
chore(deps): bump cypress to 13.x
refactor(solver): extract naked-pairs into dedicated technique
test(input-modes): add keyboard shortcut coverage
ci(workflow): add Vitest + Cypress gate on PRs to develop
```

### Types

| Type | When |
|---|---|
| `feat` | New user-facing feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `chore` | Tooling, deps, config — no production code change |
| `refactor` | Code restructure, no behaviour change |
| `test` | Adding or updating tests |
| `ci` | CI/CD workflow changes |
| `perf` | Performance improvement |
| `style` | Formatting only (no logic change) |

### Rules

- Subject line ≤ 72 chars; lowercase after the type/scope
- **No `Co-Authored-By` line** — ever, in any repo
- No trailing period on subject
- Body (optional): blank line after subject, explain *why* not *what*
- Scope is optional but encouraged: use the directory, feature, or module name

### Scope examples for speedoku

`solver`, `generator`, `ci`, `grid`, `input`, `timer`, `stats`, `agents`, `deps`, `expo`

## Push restraint

**Never push without explicit user instruction.** Commit freely, then stop.

- After `git commit`, do not run `git push` autonomously
- Do not suggest pushing unless the user's workflow specifies it (e.g. "push after each phase" in AGENTS.md)
- `git push` is gated at project scope — you'll be prompted; don't bypass

## dotfiles exception

If the current repo is the **dotfiles** project (`/Users/mb/Documents/projects/dotfiles` or any path containing `dotfiles/`), **do not use this skill**. Load the local `mb-dotfiles-committing` skill instead — it uses a different message style by design.
