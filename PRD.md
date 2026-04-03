# dotfiles PRD
> Living document. Last updated: 2026-04-04.

## Vision

A single, clean dotfiles repository that captures an intentional, terminal-centric
development environment. Every tracked file should be production-ready: no commented-out
experiments, no embedded documentation bloat, no unresolved TODOs. Experimental work lives
in `working/` (gitignored), not in committed configs.

### Principles

1. **One config at a time** -- focus switches explicitly, never refactor in the background
2. **Clean before commit** -- move experiments to `working/`, resolve TODOs, then commit
3. **Minimal and intentional** -- understand before changing, every line earns its keep
4. **Consistent aesthetic** -- Catppuccin (Macchiato), IosevkaTerm Nerd Font, vim keybindings everywhere
5. **Separate concerns** -- CLI tools live in their own repos, configs reference them

---

## Environment

| Tool | Role | Config file(s) |
|------|------|----------------|
| zsh | Shell | `.zshrc`, `.zprofile` |
| starship | Prompt | `.config/starship.toml` |
| nvim | Editor | `.config/nvim/init.lua` |
| kitty | Terminal | `.config/kitty/kitty.conf`, `.config/kitty/current-theme.conf` |
| btop | System monitor | `.config/btop/btop.conf` |
| zed | GUI editor | `.config/zed/settings.json` |
| gh | GitHub CLI | `.config/gh/config.yml` |
| git | Version control | `.config/git/ignore` |

### Shell ecosystem (installed via Homebrew)

eza, bat, dust, ripgrep, fd, zoxide, fzf, delta, starship, btop, zsh-vi-mode,
zsh-syntax-highlighting, zsh-autosuggestions, zsh-history-substring-search,
zsh-completions

### Not tracked

| Tool | Reason |
|------|--------|
| 1Password CLI | Runtime state / credentials |
| PulseAudio | Runtime symlinks |
| qBittorrent | App-managed, not handcrafted |
| Raycast | App-managed, may contain keys |

---

## Config Status

Status key: `DONE` = clean and committed | `WIP` = active cleanup | `TODO` = not yet started | `SKIP` = do not track

### Tracked configs

| Config | Status | Notes |
|--------|--------|-------|
| nvim/init.lua | DONE | Philosophy-driven minimal config. lazy.nvim, 7 plugins, <=20 mappings. |
| zed/settings.json | DONE | Fleet Dark Purple theme, vim mode, LM Studio integration. |
| starship.toml | DONE | Catppuccin Macchiato powerline. 4 palettes with neutral grays. Morse tutor marked for morsel replacement. |
| .zshrc | DONE | Profiling toggle, cached compinit/brew, delta, zoxide --cmd cd. |
| btop.conf | DONE | 88 lines. Everforest dark, vim keys, braille graphs. |
| kitty.conf | DONE | 9 lines. IosevkaTerm + Catppuccin Macchiato. |
| gh/config.yml | DONE | hosts.yml gitignored (credentials). |
| git/ignore | DONE | Global gitignore. |

### Legacy files (tracked, future triage)

| File | Notes |
|------|-------|
| .bash_* | Here be dragons. 2011-2020. Superseded by zsh. Kept for zsh-less servers. |
| .dir_colors | 2017. Superseded by eza. |
| .inputrc | 2017. Readline config, still useful for bash-based tools. |
| .screenrc | 2017. Superseded by tmux. |
| .tmux.conf | TODO: revisit. 2017. Still relevant if tmux is used. |

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

### Phase 3: Rust CLI integrations (blocked on separate projects)

- [ ] **3.1** Replace starship Python morse code block with `morsel` CLI invocation
- [ ] **3.2** Replace zsh exit/login message with dedicated Rust TUI tool

### Ongoing

- Keep `.gitignore` current
- Update this PRD as tasks complete
- One config = one commit with descriptive message
- Experiments go in `working/`, never in committed files

---

## Planned Rust CLI Tools

### morsel
Morse code tutor and conversion swiss pocket knife. Will replace the inline Python
in `starship.toml`'s `custom.anchor` module. See `working/morsel-design-notes.md` for
CLI design notes. Separate repo.

### aloha
TUI for shell dashboards. Can be used interactively or in one shot. Use cases
include interactive dashboards, login/logout messages, prompt sections, and
more. Will use `.zlogin`, `.zlogout`, and `zshexit()` functions. Separate repo.
See `working/zshrc-exit-ideas.txt` for design notes.

---

## Profiling

### Approach
Use zsh built-ins only. No external plugins needed.

- `zsh/zprof` module -- per-function call profiling
- `$EPOCHREALTIME` from `zsh/datetime` -- wall-clock timing
- Toggle: `ZSH_PROFILE=1` in `.zshrc` (flip to 0 when done)

### Usage

Set `ZSH_PROFILE=1` in `.zshrc`, open a new shell. See `working/zsh-profiling-guide.md`
for how to read the output.

### Log location

`logs/zsh-profile-YYYYMMDD-HHMMSS.log` (gitignored, no rotation, delete manually)

---

## Directory Structure

```
dotfiles/
  .config/          # XDG config directory
  working/          # scratchpad for experiments and extracted code (gitignored)
  logs/             # profiling and debug logs (gitignored)
  PRD.md            # this file
  TESTING.md        # verification checklists
  README.md         # project overview
```
