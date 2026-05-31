---
name: mb-dotfiles-committing
description: Use when about to run `git commit` in the dotfiles repo, when drafting a commit message for this repo, or when staging files for commit. Also use when noticing commented-out experimental code in tracked files just before commit. Symptoms include drafting a `prefix:` style message, drafting a Co-Authored-By line, staging changes that span more than one config, or seeing commented-out experimental snippets in the diff.
---

# mb-dotfiles-committing

## Overview

Dotfiles-specific overlay on top of the user-scope `mb-committing` skill. **Load `mb-committing` first**, then apply the overrides below. Where these rules conflict with `mb-committing`, this file wins — dotfiles is the exception repo.

**Base rules from `mb-committing` that still apply:** no Co-Authored-By, push restraint (never push without explicit instruction).

**Overrides from this file:** message style (natural language, not conventional commits), scope discipline, pre-commit hygiene.

## Message style

- **Lowercase, natural-language sentence.** No file-prefix-colon convention.
- **No `Co-Authored-By` line.** Ever.
- Elaborate in body if needed; subject stays one tight sentence.

| Good | Bad |
|---|---|
| `fix starship read_only style, swap PUA glyph for ⚡︎` | `starship: fix read_only style` |
| `nuke tmux — zellij is the answer; phase 3.20 done` | `tmux: remove (replaced by zellij)` |
| `add testing checklists for brew sync, btop, zellij` | `testing: add checklists` |

Use `git log -10 --oneline` to sample current style before drafting.

## Scope: one config = one commit

If the diff spans two unrelated configs (e.g. `.config/zsh/` + `.config/ghostty/`), split into two commits before committing. Don't bundle.

Coupled changes are an exception: if editing one config genuinely requires editing another (e.g. zshrc references a new ghostty feature), it's one logical change → one commit.

## Pre-commit hygiene: experimental code → `working/`

Before committing, scan the staged diff for **commented-out experimental snippets**. Mo procrastinates on commits because of these — they create "what if I need this later" anxiety.

**The move:**
1. Cut the commented experimental block out of the tracked file
2. Paste it into `working/<config-name>-experiments.md` (or similar)
3. `working/` is gitignored — the idea is preserved, the tracked file is clean
4. Commit the clean diff

**`working/` rules** (from AGENTS.md:47): scratchpad for experiments and test fixtures only. No long-term docs or instructions live there — anything that needs to persist goes in a tracked file.

## Push restraint

**Never push without explicit user instruction.** Commit freely, then stop.

- After `git commit`, do not run `git push`
- Do not suggest pushing
- Wait for the user to say "push" (or equivalent)

**Why this exists:** Mo wants to test changes locally before they hit origin, especially mid-experiment.

## Quick checklist

Before running `git commit`:

- [ ] Message: lowercase, natural sentence, no `prefix:`, no Co-Authored-By
- [ ] Scope: diff covers one config (or one coupled change)
- [ ] Diff has no commented-out experimental code (moved to `working/` if any)
- [ ] After commit: STOP. Do not push.

## Common mistakes

- Drafting `<config>: <change>` because the rest of the world uses that convention — wrong for this repo
- Adding `Co-Authored-By: Claude` — explicitly disallowed
- Letting commented-out test snippets ship in the tracked file
- Running `git push` after commit because it "felt complete"
- Bundling unrelated configs into one commit because they were edited together this session
