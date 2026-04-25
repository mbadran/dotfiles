# dotfiles project — agent instructions

## Session start

Run at the start of every session, report findings before starting work:

1. **Drift check** — see [Drift management](#drift-management) below
2. **Config scan** — `ls .config/` for untracked dirs; cross-reference `.gitignore` and `non-brew-apps.md`
3. **TODO/FIXME scan** — see [TODO/FIXME hygiene](#todofixme-hygiene) below

## Workflow

- Manage tasks and focus within PRD.md; update it after relevant changes
- Update README.md, TESTING.md, and brew artefacts after relevant changes
- Keep `.gitignore` and `non-brew-apps.md` current
- One config = one commit

## Commit style

- Lowercase sentence, no file prefix
- Good: `fix starship read_only style, swap PUA glyph`
- Bad: `starship: fix read_only`
- No co-author line

## Editing style

- Surgical one-at-a-time changes — never rewrite a whole file unless explicitly asked
- Don't refactor unless focus explicitly switches to that task
- No speculative cleanup, extra features, or "while I'm here" changes

## Tables

Column-aligned cells padded to widest value per column, outer `|` borders, separator rows matching column width. Readable as plain text. Horizontal scrolling is fine; never hard-wrap cell content.

## Drift management

Check for config and package drift at session start and at each phase polish step.

**Config drift:**
Check project root and `.config/` for untracked dirs. If new configs exist that are neither tracked nor referenced in `non-brew-apps.md`, either track them or add with a note to that file and `.gitignore`. If tracked configs are absent on the system, install them or remove their references.

**Brew drift:**
```
brew bundle check --verbose          # verify all Brewfile deps are installed
brew bundle cleanup                  # primary: installed packages NOT in Brewfile
brew leaves --installed-on-request   # wider net: all manually installed formulae
```

For a cross-check against the Brewfile:
```python
python3 -c "
import re, subprocess
with open('.config/brew/Brewfile') as f:
    tracked = set(re.findall(r'brew .([^\"]+).', f.read()))
leaves = set(subprocess.check_output(['brew','leaves','--installed-on-request']).decode().split())
print('untracked:', sorted(leaves - tracked))
"
```

- Skip packages shown as "Installed (as dependency)" in `brew info` — auto-pulled deps
- Present untracked installs and prompt user: add to Brewfile (with description + section) or document in `non-brew-apps.md`

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

The Write and Edit tools strip Powerline/PUA glyphs from format strings. Use Python for any line in `starship.toml` that contains such characters:

```bash
python3 -c "
with open('.config/starship.toml', 'r') as f:
    content = f.read()
content = content.replace('OLD', 'NEW')
with open('.config/starship.toml', 'w') as f:
    f.write(content)
"
```

## Key files

| File                            | Role                                                          |
| ------------------------------- | ------------------------------------------------------------- |
| `PRD.md`                        | Living roadmap — update after relevant changes                |
| `AGENTS.md`                     | This file — agent instructions (single source of truth)       |
| `CLAUDE.md`                     | Thin pointer to AGENTS.md for Claude Code                     |
| `TESTING.md`                    | Verification checklists — update after changes                |
| `README.md`                     | Project overview — update stats after changes                 |
| `.config/brew/Brewfile`         | Package manifest — maintain descriptions/sections             |
| `.config/brew/non-brew-apps.md` | Apps not managed by brew                                      |
| `.config/git/ignore`            | Global gitignore (XDG default, applies to all repos)          |
| `.config/macmon.json`           | macmon perf monitor config                                    |
| `.config/nvim/init.lua`         | Neovim config — plugins, mappings, options                    |
| `.config/zsh/.zshrc`            | Interactive shell config (symlinked from `~/.zshrc`)          |
| `.config/zsh/.zprofile`         | Login shell config (symlinked from `~/.zprofile`)             |
| `.claude/settings.json`         | Project Claude Code permissions — review each phase           |
| `.gitignore`                    | Per-repo gitignore — keep current                             |
