---
name: mb-starship-powerline-glyph-edit
description: Use when editing `.config/starship.toml`, especially the `format = """..."""` or `right_format = """..."""` blocks, or when starship prompt glyphs render as missing/blank/replacement characters after an edit. Symptoms include broken pill/chevron transitions, missing rounded caps on the prompt, or a prompt that suddenly looks "flat".
---

# mb-starship-powerline-glyph-edit

## Overview

The Write and Edit tools pass content through a text channel that **strips Unicode Private Use Area (U+E000–U+F8FF) codepoints**. Starship's powerline transitions use exactly those codepoints. Editing the format strings with Write or Edit silently destroys the glyphs and produces a flat, broken prompt.

**Supplementary PUA-B nerd font icons (U+F0000+) survive** — only the basic PUA range is affected. That's why most nerd-font icons in starship survive but powerline transitions don't.

## When to use

- About to edit `format = """..."""` or `right_format = """..."""` in `.config/starship.toml`
- A prior edit to starship.toml left the prompt rendering wrong
- About to do find/replace on any line containing powerline characters

## When NOT to use

- Editing non-format sections of starship.toml (`[git_branch]`, module configs, palette definitions) → Edit/Write is fine
- Editing fields that contain only PUA-B (U+F0000+) nerd icons (these survive the text channel)

## The glyphs

| Codepoint | Visual role | Expected count in current starship.toml |
|---|---|---|
| `U+E0B6` | left half-circle (rounded left cap of left prompt) | 2 |
| `U+E0B0` | right chevron (transitions between left prompt segments) | 4 |
| `U+E0B2` | left chevron (transitions between right prompt segments) | 8 |
| `U+E0B4` | right half-circle (rounded right cap of right prompt) | 2 |

Total: **16 powerline glyphs** in the format blocks.

## How to edit (use Python via Bash)

```bash
python3 -c "
with open('.config/starship.toml', 'r') as f:
    content = f.read()
content = content.replace('OLD', 'NEW')
with open('.config/starship.toml', 'w') as f:
    f.write(content)
"
```

Python reads/writes raw bytes — the PUA codepoints round-trip cleanly.

## Verify after any edit

Construct glyphs from codepoints via `chr()` — portable across any tool that might strip PUA:

```bash
python3 -c "
with open('.config/starship.toml') as f:
    s = f.read()
for cp, name in [(0xE0B6, 'left-cap'), (0xE0B0, 'right-chev'),
                 (0xE0B2, 'left-chev'), (0xE0B4, 'right-cap')]:
    print(f'U+{cp:04X} {name}: {s.count(chr(cp))}')
"
```

Expected output: `2 / 4 / 8 / 2`. Any deviation means glyphs were stripped — restore from git.

## Common mistakes

- Using Edit to "just tweak one segment" in `format = """..."""` — even a small Edit that touches a line containing PUA strips them silently
- Forgetting to run verification after the edit and only catching the breakage at the next terminal restart
- Trying to paste glyphs from web sources — many render correctly but encode as a different/wider codepoint; only the U+E0B0/B2/B4/B6 set works with the current font

## Red flags — STOP and use Python

- About to call Edit with `format` or `right_format` in `old_string` or `new_string`
- About to call Write on starship.toml
- About to paste a powerline character from elsewhere
