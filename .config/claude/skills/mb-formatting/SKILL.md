---
name: mb-formatting
description: Use when editing Markdown (`.md`), zsh config (`.zshrc`/`.zshenv`/`.zprofile`), Lua config (`init.lua`), or any tracked human-read documentation. Triggers on writing section header comments, building/editing Markdown tables, writing prose paragraphs in docs, or seeing trailing whitespace. Symptoms include misaligned table columns, inconsistent header decoration within one file, prose paragraphs that don't wrap, or trailing spaces at end of lines.
---

# mb-formatting

## Overview

Mo's personal editorial style for tracked files. Four concerns: section headers, Markdown tables, prose wrap, trailing whitespace.

## Section headers in code files

Two styles. **Both fill to exactly column 80**, using the file's comment character as the fill.

**H1 — top-level section, right-aligned (fill leads, text trails):**

```
# shell file (.zshrc, .zshenv, .zprofile)
################################################################## zsh base dirs
########################################################## zsh profiling (start)

-- lua file (nvim init.lua, page init.lua)
------------------------------------------------------------------ options ♠ ---
------------------------------------------------------------------ plugins ♠ ---
```

**H2 — sub-section under an H1, left-aligned (text leads, fill trails):**

```
# shell
### claude #####################################################################
### nodejs helpers #############################################################

-- lua
--- ♠ visibility ---------------------------------------------------------------
--- ♠ buffers ------------------------------------------------------------------
```

**Rules:**

- Total line length: exactly 80 chars
- Single space between fill and title (both sides for H1, one side for H2)
- Same comment char used for fill as for line comments (`#` for shell, `-` for lua)
- The `♠` in nvim files is **functional, not decorative** — it marks Mo's custom mappings so `filter /♠/ map` can list them. Never strip it
- Lua H1 keeps the `♠ ---` suffix as part of the standard

## Markdown tables

Reference style: the AGENTS.md "Key files" table at the bottom of that file. Rules:

- Outer `|` borders on every row
- One space before and one space after each `|`
- Cells padded with trailing spaces to match the widest cell in their column
- Separator row uses `-` characters padded to the same column widths
- Never hard-wrap cell content — horizontal scroll is fine, line breaks inside cells are not

**Sort table rows alphabetically when not order-dependent.** Order-dependent rows = numbered task lists (PRD), workflow steps, prioritized lists. Reference tables (key files, glyph counts, alias lists) sort alphabetically by first column.

## Prose wrap

**Wrap at column 80** in human-read docs: `README.md`, `AGENTS.md`, `PRD.md`, `TESTING.md`, `.config/*/README.md`, and tracked notes in `working/`.

**Don't wrap:** memory files (`memory/*.md`), inline comments inside code, ASCII art / banner blocks, Markdown table rows (per above).

Soft-wrap by visible character count; treat punctuation, code spans, and links as part of the line they conclude. Avoid breaking immediately after `(` or before `)`/`,`/`.`.

## Trailing whitespace

Strip on every save. No spaces or tabs at end of line. Mo hates it.

Quick check:

```bash
grep -nE ' +$' <file>
```

Empty output = clean.

## Common mistakes

- Mixing H1 and H2 styles within a single section (use H1 for the top of a section, H2 for everything nested under it)
- Stripping the `♠` from nvim headers or keymap descriptions — breaks the `filter /♠/ map` functionality
- Hard-wrapping inside a Markdown table cell (use horizontal scroll, never wrap)
- Wrapping memory files (they're machine-loaded; wrap adds noise without benefit)
- Sorting numbered PRD/task rows alphabetically — those stay in their authored order
- Leaving trailing whitespace after a refactor (diff hygiene fails)

## Quick reference

| Concern | Rule |
| ------- | ---- |
| H1 (right-aligned) | `<fill>...<fill> title` to col 80 |
| H2 (left-aligned) | `<prefix> title <fill>...<fill>` to col 80 |
| Markdown table | `|` borders with spaces, cells padded to widest, no cell wrapping |
| Table row order | Alphabetical unless numbered/positional |
| Prose wrap | Col 80 in human-read docs only |
| Memory files | No wrap (single-line bullets) |
| Trailing whitespace | Strip always |
| Nvim `♠` | Preserve — it's functional |
