# Dotfiles PRD

> Living document. Last updated: 2026-04-03.

## Vision

A single, clean dotfiles repository that captures an intentional, terminal-centric
development environment. Every tracked file should be production-ready: no commented-out
experiments, no embedded documentation bloat, no unresolved TODOs. Experimental work lives
in `working/` (gitignored), not in committed configs.

### Principles

1. **One config at a time** -- focus switches explicitly, never refactor in the background
2. **Clean before commit** -- move experiments to `working/`, resolve TODOs, then commit
3. **Minimal and intentional** -- every line earns its place
4. **Consistent aesthetic** -- Catppuccin Macchiato, IosevkaTerm Nerd Font, vim keys everywhere
5. **Separate concerns** -- Rust CLI tools live in their own repos, configs reference them

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
| alacritty | Terminal (alt) | `.config/alacritty/alacritty.toml` |

### Shell ecosystem (installed via Homebrew)

eza, bat, dust, ripgrep, fd, zoxide, fzf, starship, btop, zsh-vi-mode,
zsh-syntax-highlighting, zsh-autosuggestions, zsh-history-substring-search,
zsh-completions

### Not tracked

| Tool | Reason |
|------|--------|
| karabiner | Not used -- uninstall from macOS |
| 1Password CLI | Runtime state / credentials |
| PulseAudio | Runtime symlinks |
| qBittorrent | App-managed, not handcrafted |
| Raycast | App-managed, may contain keys |

---

## Config Status

Status key: `DONE` = clean and committed | `WIP` = active cleanup | `QUEUED` = not yet started | `SKIP` = do not track

### Tracked configs

| Config | Status | Notes |
|--------|--------|-------|
| nvim/init.lua | DONE | Philosophy-driven minimal config. lazy.nvim, 7 plugins, <=20 mappings. Ready to push. |
| zed/settings.json | DONE | Clean. Fleet Dark Purple theme, vim mode, LM Studio integration. |
| starship.toml | DONE | Cleaned. 4 palettes with neutral grays. Morse tutor marked for morsel replacement. |
| .zshrc | DONE | Cleaned. Profiling foundations added (ZSH_PROFILE=1). Exit logic parked for Rust TUI. |
| btop.conf | DONE | Stripped to 88 lines. Everforest dark, vim keys, braille graphs. |
| kitty.conf | DONE | Stripped from 2939 to 9 lines. IosevkaTerm + Catppuccin Macchiato. |
| gh/config.yml | DONE | Tracked. hosts.yml gitignored (credentials). |
| git/ignore | DONE | Tracked. |

### Legacy files (tracked, future triage)

| File | Notes |
|------|-------|
| .bash_* | Here be dragons. 2011–2020. Superseded by zsh. Kept for zsh-less servers. |
| .dir_colors | 2017. Superseded by eza. |
| .inputrc | 2017. Readline config, still useful for bash-based tools. |
| .screenrc | 2017. Superseded by tmux. |
| .tmux.conf | 2017. Still relevant if tmux is used. |

---

## Roadmap

### Phase 1: Foundation (current)

- [x] **1.1** Create PRD, testing guide, and project roadmap
- [x] **1.2** Create `working/` and `logs/` directories, update `.gitignore`
- [x] **1.3** Clean up `starship.toml`:
  - Extract commented-out alternatives to `working/starship-notes.toml`
  - Extract morsel CLI design notes to `working/morsel-design-notes.md`
  - Remove stale comments and unused code
  - Add neutral grays (gray, silver, charcoal) to all 4 palettes
  - Mark morse code tutor with `# REPLACE: morsel`
  - Commit
- [x] **1.4** Clean up `.zshrc`:
  - Extract broken exit logic to `working/zshrc-exit-ideas.txt`
  - Remove commented-out code and TBD placeholders
  - Add profiling foundations (zprof + EPOCHREALTIME, off by default)
  - Commit
- [x] **1.5** Push all commits to origin

### Phase 2: Triage and cleanup (near-term)

- [x] **2.1** Track `.config/gh/config.yml` (gitignore hosts.yml)
- [x] **2.2** Track `.config/git/ignore`
- [x] **2.3** Clean up `btop.conf` -- stripped to 88 lines, active config only
- [x] **2.4** Clean up `kitty.conf` -- stripped from 2939 to 9 lines
- [x] **2.5** Legacy bash files tagged with here-be-dragons warning, kept for zsh-less servers
- [ ] **2.6** Delete `starship.toml.catppuccin` and `starship.toml.orig` (or move to `working/`)
- [ ] **2.7** Add per-file profiling markers (wrap each `source` call with timing)
- [x] **2.8** Update README.md with stats and env-var section style
- [x] **2.9** Cache compinit with daily rebuild
- [x] **2.10** Cache brew --prefix (called 6 times)
- [x] **2.11** Replace cd=z alias with zoxide --cmd cd (fixes non-interactive scripts)
- [x] **2.12** Add delta as diff replacement (installed via brew)
- [x] **2.13** Add zsh history config (10k, shared, deduped)
- [x] **2.14** Revisit README with something more whimsical

### Phase 3: Rust CLI integrations (future, blocked on separate projects)

- [ ] **3.1** Replace starship Python morse code block with `morsel` CLI invocation
- [ ] **3.2** Replace zsh exit/login message with dedicated Rust TUI tool (uses .zlogin/.zlogout/zshexit())
- [ ] **3.3** Add custom plugin timing to profiling logs
- [ ] **3.4** Revisit starship/zshrc/other configs as Rust tools mature

### Ongoing

- Keep `.gitignore` current
- Update this PRD as tasks complete (flip `[ ]` to `[x]`, update status table)
- One config = one commit with descriptive message
- Experiments go in `working/`, never in committed files

---

## Planned Rust CLI Tools

### morsel
Morse code tutor and conversion swiss pocket knife. Will replace the inline Python
in `starship.toml`'s `custom.anchor` module. See `working/morsel-design-notes.md` for
CLI design notes. Separate repo.

### Exit/Login TUI
Custom TUI for shell login/logout messages. Will use `.zlogin`, `.zlogout`, and
`zshexit()` function. Replaces the broken `cleanup()` function in `.zshrc`. Separate repo.
See `working/zshrc-exit-ideas.txt` for design notes.

---

## Profiling

### Approach
Use zsh built-ins only. No external plugins needed.

- `zsh/zprof` module -- per-function call profiling
- `$EPOCHREALTIME` from `zsh/datetime` -- high-precision wall-clock timing
- `$SECONDS` -- session duration (integer, built-in)

### Usage

```sh
# Profile zsh startup (off by default, zero overhead)
ZSH_PROFILE=1 zsh -i -c exit

# Change log directory
ZSH_LOG_DIR=/tmp/zsh-logs ZSH_PROFILE=1 zsh -i -c exit
```

### What we profile

| Metric | Method | Phase |
|--------|--------|-------|
| Total zsh startup time | `$EPOCHREALTIME` delta top-to-bottom of `.zshrc` | Phase 1 |
| Per-function breakdown | `zprof` output | Phase 1 |
| Session duration | `$SECONDS` in exit hook | Phase 2 (Rust TUI) |
| Per-file source time | `$EPOCHREALTIME` wrappers around each `source` call | Phase 2 |
| `.zlogin` / `.zlogout` timing | Same `$EPOCHREALTIME` approach | Phase 2 |
| Custom plugin timing | Plugins report own timing to log dir | Phase 3 (Rust tools) |

### Log location

`./logs/zsh-profile-YYYYMMDD-HHMMSS.log` (gitignored)

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
