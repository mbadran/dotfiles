# dotfiles PRD
> Living document. Last updated: 2026-04-21.

## Vision

A single, clean dotfiles repository for an intentional, terminal-centric development environment. Every tracked file is production-ready — no commented-out experiments, no documentation bloat, no unresolved TODOs.

## Principles

1. **One config at a time** — focus switches explicitly, never refactor in the background
2. **Minimal and intentional** — understand before changing, every line earns its keep
3. **Consistent aesthetic** — Catppuccin (Macchiato), IosevkaTerm Nerd Font, vim keybindings everywhere
4. **Separate concerns** — CLI tools live in their own repos, configs reference them
5. **Production-ready only** — experiments go in `working/`, never in committed files

## Guardrails

**Workflow** — enforce Principle 1 and 5
- Manage tasks and focus within this PRD; update it after relevant changes
- Update README.md, TESTING.md, and brew artefacts after relevant changes
- Keep `.gitignore` current

**Commits** — enforce Principle 2
- One config = one commit with a descriptive message
- Style: lowercase sentence, no file prefix — e.g. *"fix starship read_only style, swap PUA glyph"* not *"starship: fix read_only"*

**Drift management** — enforce Principle 1 and 5
- At the start of each session, check for untracked configs in project root and `.config/`. Run `brew bundle check --verbose`. If new configs exist that are neither tracked nor referenced in `./brew/non-brew-apps.md`, either track them or add them (with a note) to that file and `.gitignore`. If tracked configs are absent on the system, install them or remove their references.

**Tables** — enforce Principle 2
- Column-aligned cells padded to widest value per column, outer `|` borders, separator rows matching column width. Readable as plain text. Horizontal scrolling is fine; never hard-wrap cell content.

---

## Environment

### Directory structure

```
dotfiles/
  .config/          # XDG config directory
    brew/           # homebrew: Brewfile, brew.env, non-brew-apps.md
  working/          # scratchpad for experiments and extracted code (gitignored)
  logs/             # profiling and debug logs (gitignored)
  PRD.md            # this file
  TESTING.md        # verification checklists
  README.md         # project overview
```

### Bundles and packages

> Managed via [Homebrew](https://brew.sh). See [`.config/brew/README.md`](.config/brew/README.md) for the full package list.

### Key tools

| Tool     | Role            | Config file(s)                                                 |
| -------- | --------------- | -------------------------------------------------------------- |
| btop     | System monitor  | `.config/btop/btop.conf`                                       |
| gh       | GitHub CLI      | `.config/gh/config.yml`                                        |
| git      | Version control | `.config/git/ignore`                                           |
| homebrew | Package manager | `.config/brew/Brewfile`, `.config/brew/brew.env`               |
| kitty    | Terminal        | `.config/kitty/kitty.conf`, `.config/kitty/current-theme.conf` |
| nvim     | Editor          | `.config/nvim/init.lua`                                        |
| starship | Prompt          | `.config/starship.toml`                                        |
| zed      | GUI editor      | `.config/zed/settings.json`                                    |
| zsh      | Shell           | `.zshrc`, `.zprofile`                                          |

### Tracked configs

| Config            | Description                                                 |
| ----------------- | ----------------------------------------------------------- |
| .zprofile         | Login shell — brew shellenv, Homebrew env vars              |
| .zshrc            | Interactive shell — vi-mode, plugins, aliases, pager wiring |
| btop.conf         | System monitor — Everforest theme, vim keys                 |
| ccstatusline      | Statusline for Claude Code sessions                         |
| gh/config.yml     | GitHub CLI (hosts.yml gitignored)                           |
| git/ignore        | Global gitignore patterns                                   |
| homebrew          | Brewfile + brew.env + non-brew-apps index                   |
| kitty.conf        | GPU terminal emulator                                       |
| nvim/init.lua     | Neovim — minimal, lazy.nvim, 8 plugins                      |
| page/init.lua     | Neovim-based pager for less/man/more                        |
| starship.toml     | Starship prompt — Catppuccin Macchiato                      |
| zed/settings.json | Zed GUI editor                                              |

### Retired configs 

_Tracked for future triage_

| Config      | Notes                                                                     |
| ----------- | ------------------------------------------------------------------------- |
| .bash_*     | Here be dragons. 2011-2020. Superseded by zsh. Kept for zsh-less servers. |
| .dir_colors | 2017. Superseded by eza.                                                  |
| .inputrc    | 2017. Readline config, still useful for bash-based tools.                 |
| .tmux.conf  | TODO: revisit. 2017. Still relevant if tmux is used.                      |

---

## Profiling

### Approach

Use zsh built-ins only. No external plugins needed.

- `zsh/zprof` module -- per-function call profiling
- `$EPOCHREALTIME` from `zsh/datetime` -- wall-clock timing
- Toggle: `ZSH_PROFILE=1` in `.zshrc` (flip to 0 when done)

### Usage

Set `ZSH_PROFILE=1` in `.zshrc`, open a new shell. See `working/zsh-profiling-guide.md` for how to read the output.

### Log location

`logs/zsh-profile-YYYYMMDD-HHMMSS.log` (gitignored, no rotation, delete manually)

---

## Roadmap

### Status legend

`TODO` = Not Started | `FIXME` = Bug | `WIP` = Active Cleanup | `DONE` = Clean And Committed |`SKIP` = Do Not Track

### Phase 1: Foundation -- DONE

- [x] **1.1** Create PRD, testing guide, and project roadmap
- [x] **1.2** Create `working/` and `logs/` directories, update `.gitignore`
- [x] **1.3** Clean up `starship.toml`
- [x] **1.4** Clean up `.zshrc`
- [x] **1.5** Push all commits to origin

### Phase 2: Triage and cleanup -- DONE

- [x] **2.1** Track `.config/gh/config.yml` (gitignore hosts.yml)
- [x] **2.2** Track `.config/git/ignore`
- [x] **2.3** Clean up `btop.conf` -- stripped to 88 lines
- [x] **2.4** Clean up `kitty.conf` -- stripped from 2939 to 9 lines
- [x] **2.5** Legacy bash files tagged with here-be-dragons warning
- [x] **2.6** Move `starship.toml.catppuccin` and `.orig` to `working/`
- [x] ~~**2.7** Per-file profiling markers~~ -- canceled, zprof covers this
- [x] **2.8** Update README.md with stats and env-var section style
- [x] **2.9** Cache compinit with daily rebuild
- [x] **2.10** Cache brew --prefix
- [x] **2.11** Replace cd=z alias with zoxide --cmd cd
- [x] **2.12** Add delta as diff replacement
- [x] **2.13** Add zsh history config (10k, shared, deduped)
- [x] **2.14** Revisit README with something more whimsical
- [x] **2.15** Fix profiling: hardcode log dir, better output, usage guide
- [x] **2.16** Fix starship home_symbol (BMP PUA glyph)
- [x] **2.17** Retire alacritty config (no longer maintained as cask, kitty replaces it)

### Phase 3: Stragglers and polish

- [x] **3.1** Incorporate latest changes, fix zoxide warning, and polish
- [x] **3.2** Track ccstatusline config
- [x] **3.3** Update pager config (via page)
- [x] **3.4** Develop a brewfile to manage future mac migrations
- [ ] **3.5** Replace downloaded apps and binaries with brew equivalents
- [ ] **3.6** Import and symlink key ~/.claude settings (gitignoring the rest)
- [ ] **3.7** Fix `page -p` PTY redirect (`ls > $(page -p)` fails -- neovim startup emits ANSI escape codes before the device path, corrupting the `$()` expansion)

### Phase 4: morsel

- [ ] **4.1** Replace starship Python morse code block with `morsel` CLI calls
- [ ] **4.2** Polish

### Phase 5: aloha

- [ ] **5.1** Replace zsh login/logout message with `aloha` CLI calls
- [ ] **5.2** Polish

### Phase 6: neopager

- [ ] **6.1** Replace `page` + neovim pager with `neopager`
- [ ] **6.2** Polish

---

## Planned TUI tools

### morsel

Morse code tutor and conversion swiss pocket knife. Will replace the inline Python in `starship.toml`'s `custom.anchor` module. Separate repo. See `working/morsel-design-notes.md` for design notes.

### aloha

TUI for shell dashboards. Can be used interactively or in one shot. Use cases include interactive dashboards, login/logout messages, prompt sections, and more. Will use `.zlogin`, `.zlogout`, and `zshexit()` functions. Separate repo. See `working/zshrc-exit-ideas.txt` for design notes.

### neopager

A from-scratch pager built in Rust. Intended to replace `page` (which wraps neovim) with a standalone binary that has no neovim dependency but keeps the same UX contract: syntax highlighting, vi keys, and the ability to act as a drop-in for less/man/more. Alternatively, integrates with neovim in headless mode. Separate repo. See `working/NEOPAGER-PRD.md` for design notes.
