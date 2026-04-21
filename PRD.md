# dotfiles PRD
> Living document. Last updated: 2026-04-21.

## Vision

A single, clean dotfiles repository that captures an intentional, terminal-centric development environment. Every tracked file should be production-ready: no commented-out experiments, no embedded documentation bloat, no unresolved TODOs. Experimental work lives in `working/` (gitignored), not in committed configs.

### Principles

1. **One config at a time** -- focus switches explicitly, never refactor in the background
2. **Clean before commit** -- move experiments to `working/`, resolve TODOs, then commit
3. **Minimal and intentional** -- understand before changing, every line earns its keep
4. **Consistent aesthetic** -- Catppuccin (Macchiato), IosevkaTerm Nerd Font, vim keybindings everywhere
5. **Separate concerns** -- CLI tools live in their own repos, configs reference them

---

## Environment

| Tool     | Role            | Config file(s)                                                 |
| -------- | --------------- | -------------------------------------------------------------- |
| zsh      | Shell           | `.zshrc`, `.zprofile`                                          |
| starship | Prompt          | `.config/starship.toml`                                        |
| nvim     | Editor          | `.config/nvim/init.lua`                                        |
| kitty    | Terminal        | `.config/kitty/kitty.conf`, `.config/kitty/current-theme.conf` |
| btop     | System monitor  | `.config/btop/btop.conf`                                       |
| zed      | GUI editor      | `.config/zed/settings.json`                                    |
| gh       | GitHub CLI      | `.config/gh/config.yml`                                        |
| git      | Version control | `.config/git/ignore`                                           |
| homebrew | Package manager | `.config/brew/Brewfile`, `.config/brew/brew.env`               |

### Shell ecosystem 

> Managed via [Homebrew](https://brew.sh)

bat, btop, delta, dust, eza, fd, fzf, ripgrep, starship, zoxide, zsh-autosuggestions, zsh-completions, zsh-history-substring-search, zsh-syntax-highlighting, zsh-vi-mode

### Not tracked (TODO: review)

| Tool          | Reason                        |
| ------------- | ----------------------------- |
| Raycast       | App-managed, may contain keys |
| qBittorrent   | App-managed, not handcrafted  |
| 1Password CLI | Runtime state / credentials   |
| PulseAudio    | Runtime symlinks              |

---

## Status legend

`TODO` = Not Started | `FIXME` = Bug | `WIP` = Active Cleanup | `DONE` = Clean And Committed |`SKIP` = Do Not Track

### Tracked configs

| Config            | Status | Notes                                                                                                                         |
| ----------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------- |
| .zshrc            | DONE   | Profiling toggle, cached compinit/brew, delta, zoxide --cmd cd, page pager/manpager, ccsl/qqwing aliases.                     |
| btop.conf         | DONE   | 88 lines. Everforest dark, vim keys, braille graphs.                                                                          |
| ccstatusline      | DONE   | Powerline statusline for Claude Code sessions.                                                                                |
| gh/config.yml     | DONE   | hosts.yml gitignored (credentials).                                                                                           |
| git/ignore        | DONE   | Global gitignore.                                                                                                             |
| homebrew          | DONE   | Brewfile + brew.env in `.config/brew/`. Taps: arthur-ficial, tonisives, vecartier. Non-brew apps indexed in non-brew-apps.md. |
| kitty.conf        | DONE   | IosevkaTerm + Catppuccin Macchiato. Remote control via socket (stream deck).                                                  |
| nvim/init.lua     | DONE   | Philosophy-driven minimal config. lazy.nvim, 7 plugins, <=20 mappings.                                                        |
| starship.toml     | DONE   | Catppuccin Macchiato powerline. 4 palettes with neutral grays. Morse tutor marked for morsel replacement.                     |
| zed/settings.json | DONE   | Fleet Dark Purple theme, vim mode, LM Studio integration.                                                                     |

### Retired configs (tracked for future triage)

| Config      | Notes                                                                     |
| ----------- | ------------------------------------------------------------------------- |
| .bash_*     | Here be dragons. 2011-2020. Superseded by zsh. Kept for zsh-less servers. |
| .dir_colors | 2017. Superseded by eza.                                                  |
| .inputrc    | 2017. Readline config, still useful for bash-based tools.                 |
| .screenrc   | 2017. Superseded by tmux.                                                 |
| .tmux.conf  | TODO: revisit. 2017. Still relevant if tmux is used.                      |

---

## Roadmap

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
- [x] **3.5** Track ccstatusline config
- [ ] **3.2** Import and symlink key ~/.claude settings (gitignoring the rest)
- [ ] **3.3** Replace downloaded apps and binaries with brew equivalents
- [x] **3.4** Develop a brewfile to manage future mac migrations

### Phase 4: TUI tools

- [ ] **4.1** Replace starship Python morse code block with `morsel` CLI calls
- [ ] **4.2** Replace zsh login/logout message with `aloha` CLI calls
- [ ] **4.3** Fix `page -p` PTY redirect (`ls > $(page -p)` fails -- neovim startup emits ANSI escape codes before the device path, corrupting the `$()` expansion)

### Ongoing

- Keep `.gitignore` current
- Manage tasks within this PRD
- Track changes within files via config status keys
- Update files and this PRD as tasks complete
- One config = one commit with descriptive message
- Commit style: lowercase sentence, no file-prefix colon, natural language — e.g. *"fix starship read_only style, swap PUA glyph"* not *"starship: fix read_only"*
- Experiments go in `working/`, never in committed files
- Table formatting: all markdown tables use column-aligned cells padded to the widest value in each column, outer `|` borders on both sides, and separator rows matching column width — readable as plain text without a markdown viewer. horizontal scrolling is fine; never hard-wrap cell content

---

## Planned Rust CLI Tools

### morsel

Morse code tutor and conversion swiss pocket knife. Will replace the inline Python in `starship.toml`'s `custom.anchor` module. See `working/morsel-design-notes.md` for CLI design notes. Separate repo.

### aloha

TUI for shell dashboards. Can be used interactively or in one shot. Use cases include interactive dashboards, login/logout messages, prompt sections, and more. Will use `.zlogin`, `.zlogout`, and `zshexit()` functions. Separate repo. See `working/zshrc-exit-ideas.txt` for design notes.

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

## Directory structure

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
