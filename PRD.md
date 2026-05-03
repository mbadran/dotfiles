# dotfiles PRD
> Living document. Last updated: 2026-05-03.

## Vision

A single, clean dotfiles repository for an intentional, terminal-centric development environment. Every tracked file is production-ready — no commented-out experiments, no documentation bloat, no unresolved TODOs.

## Principles

1. **One config at a time** — focus switches explicitly, never refactor in the background
2. **Minimal and intentional** — understand before changing, every line earns its keep
3. **Consistent aesthetic** — Catppuccin (Macchiato), IosevkaTerm Nerd Font, vim keybindings everywhere
4. **Separate concerns** — CLI tools live in their own repos, configs reference them
5. **Production-ready only** — experiments go in `working/`, never in committed files

## Guardrails

See **AGENTS.md** for all workflow, commit style, drift management, and phase polish instructions.

**Tables** — for human reference when editing this file directly
- Column-aligned cells padded to widest value per column, outer `|` borders, separator rows matching column width. Readable as plain text. Horizontal scrolling is fine; never hard-wrap cell content.

---

## Environment

### Directory structure

```
dotfiles/
  .config/              # XDG config directory (~/.config symlinks here)
    brew/               # homebrew: Brewfile, brew.env, non-brew-apps.md
    retired/
      bash/             # legacy bash configs (2011-2020)
      tmux/             # legacy tmux config (2017)
    zsh/                # zsh configs (~/.zshrc and ~/.zprofile symlink here)
  working/              # scratchpad for experiments and extracted code (gitignored)
  logs/                 # profiling and debug logs (gitignored)
  PRD.md                # this file
  TESTING.md            # verification checklists
  README.md             # project overview
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
| ghostty  | Terminal (trial)| `.config/ghostty/config`                                       |
| kitty    | Terminal        | `.config/kitty/kitty.conf`, `.config/kitty/current-theme.conf` |
| macmon   | Perf monitor    | `.config/macmon.json`                                          |
| nvim     | Editor          | `.config/nvim/init.lua`                                        |
| starship | Prompt          | `.config/starship.toml`                                        |
| zed      | GUI editor      | `.config/zed/settings.json`                                    |
| zsh      | Shell           | `.config/zsh/.zshrc`, `.config/zsh/.zprofile`                  |

### Tracked configs

| Config                  | Description                                                 |
| ----------------------- | ----------------------------------------------------------- |
| zsh/.zprofile           | Login shell — brew shellenv, Homebrew env vars              |
| zsh/.zshrc              | Interactive shell — vi-mode, plugins, aliases, pager wiring |
| btop.conf               | System monitor — Everforest theme, vim keys                 |
| ccstatusline            | Statusline for Claude Code sessions                         |
| gh/config.yml           | GitHub CLI (hosts.yml gitignored)                           |
| git/ignore              | Global gitignore patterns                                   |
| homebrew                | Brewfile + brew.env + non-brew-apps index                   |
| kitty.conf              | GPU terminal emulator                                       |
| macmon.json             | Apple Silicon perf monitor — sparkline view, green, 1s interval |
| nvim/init.lua           | Neovim — minimal, lazy.nvim, 17 plugins                     |
| page/init.lua           | Neovim-based pager for less/man/more                        |
| ghostty/config          | Ghostty terminal — IosevkaTerm 18pt, Catppuccin Macchiato   |
| starship.toml           | Starship prompt — Catppuccin Macchiato                      |
| zed/settings.json       | Zed GUI editor                                              |

### Retired configs 

_Tracked for future triage, under `.config/retired/`_

| Config                  | Notes                                                                     |
| ----------------------- | ------------------------------------------------------------------------- |
| retired/bash/.bash_*    | Here be dragons. 2011-2020. Superseded by zsh. Kept for zsh-less servers. |
| retired/bash/.dir_colors | 2017. Superseded by eza.                                                 |
| retired/bash/.inputrc   | 2017. Readline config, still useful for bash-based tools.                 |
| retired/tmux/.tmux.conf | TODO: revisit. 2017. Still relevant if tmux is used.                      |

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
- [x] **3.5** Replace downloaded apps and binaries with brew equivalents (`brew --force` takeover complete)
  - _`ovim` commented out — macOS permissions not sorted; TODO: revisit when fixed_
  - _`docker` → `docker-desktop`: cask rename_
- [x] **3.6** XDG centralization — audit `~/.config` and migrate configs safely
  - `~/.config` symlinks to dotfiles `.config/` — all configs already XDG-resident
  - zsh moved to `.config/zsh/`; `~/.zshrc` and `~/.zprofile` symlink there
  - bash/tmux retired files moved to `.config/retired/`
  - starship already at `~/.config/starship.toml` (XDG default, no move needed)
  - Claude Code: `CLAUDE_CONFIG_DIR` too buggy to use; `~/.claude/` stays untracked
  - `~/.claude/settings.json` not tracked — `env` section is a footgun for accidental API key commits; hooks may contain inline secrets. Future consideration: track a `settings-base.json` (structure/permissions only, no secrets) and manage `~/.claude/settings.json` manually.
- [x] **3.7** Multi-agent support — `CLAUDE.md` (pointer) + `AGENTS.md` (full instructions)
- [x] **3.8** Review and resolve all `TODO`/`FIXME` comments in tracked files
  - `starship.toml` ×3: `# TODO: test` on `[conda]`, `[docker_context]`, `[package]` — removed (modules work passively); test fixtures in `working/test-starship/`, instructions in TESTING.md
  - `.tmux.conf`: removed dead `# # FIXME` (double-commented, inert)
  - `.tmux.conf`: removed `# TODO: figure out a way to enable V` (legacy syntax, retired config)
  - `starship.toml`: `# TODO: REPLACE: morsel` — kept, tracked as 4.1
  - `page/init.lua`: PTY redirect TODO — kept, tracked as 3.12 (parked/superseded by neopager)
- [x] **3.9** Home dir dot-file audit — `~/.*` reviewed; one XDG migration, rest documented
  - `.gitconfig` → `.config/git/config` (XDG; git reads this automatically when `~/.gitconfig` absent)
  - `.claude.json` — Claude Code managed, stays at `~/`
  - `.lmstudio-home-pointer` — app-managed pointer, stays at `~/`
  - `.bash_history`, `.python_history`, `.zsh_history`, `.zcompdump` — runtime state, not movable
  - `.CFUserTextEncoding`, `.DS_Store` — macOS system files, not movable
  - `.viminfo` — legacy vim state (we use nvim), leave
  - `.yarnrc` — auto-generated by yarn v1 (2022), leave
- [ ] **3.10** Vim system-wide — get mac-wide vim keybindings working (ovim or alternative)
- [ ] **3.11** Neovim experiments
  - [x] lazy.nvim vs vim.pack — keep lazy.nvim (no update mechanism in vim.pack)
  - [x] mini.tabline — installed, working
  - [x] fzf-lua — installed; telescope removed; `<C-p>` uses fzf-lua
  - [x] buffer nav mappings — `<C-h>`/`<C-l>` prev/next, `<C-n>` new buffer
  - [x] verify mini.comment is needed (Neovim ≥0.10 ships `gc` natively — redundant)
  - [x] Raycast cheatsheet — `scripts/nvim/keymaps.sh` dumps `♠` mappings to `working/nvim-keymaps.md`; runs in `start.sh`
  - [ ] Neovim plugin review — audit all mini.nvim plugins and popular alternatives individually; decide what to add, replace, or drop (mini.pairs, mini.ai, mini.icons, mini.animate, etc.)
  - [ ] fzf-lua deep dive — map live_grep (`<C-t>` done), buffers, git_status, oldfiles, keymaps; explore zoxide integration for cross-project navigation
  - [ ] Dir view — evaluate alternatives to netrw+`<C-b>`; preference is non-floating, fast, minimal; netrw may be the permanent answer if alternatives add complexity (skip mini.files — floating UI not preferred)
- [-] ~~**3.12** Fix `page -p` PTY redirect~~ — SKIP: parked, superseded by phase 6 (neopager)
- [ ] **3.13** Zshrc review — drop dead-commented PATH/lmstudio lines, audit for missing modern niceties, sanity check
- [ ] **3.14** Switch zsh plugin sourcing to `antidote` (try in branch first; static-bundle mode for zero perf cost)
- [ ] **3.15** Migrate `~/.claude` config into dotfiles at `.config/claude/` (separate from project-local `.claude/`)
  - Symlink `~/.claude/settings.json` from tracked file
  - Build a base/global config sourced into project-local Claude settings to avoid repeating permissions/hooks per project
  - Move `~/.claude/*.bak*` and `*.orig` to `working/claude-backups-YYYYMMDD/`, then delete
  - `.gitignore` runtime state: `history.jsonl`, `sessions/`, `cache/`, `projects/`, `shell-snapshots/`, `file-history/`, `todos/`, `backups/`, `cc-beeper/`, `paste-cache/`, `plans/`, `plugins/`, `scheduled-tasks/`, `session-env/`, `statsig/`, `telemetry/`, `tasks/`, `mcp-needs-auth-cache.json`, `security_warnings_state_*.json`
- [ ] **3.16** Claude Code hooks — wire `start.sh`/`end.sh` into `SessionStart`/`SessionEnd` (Claude Code added these — AGENTS.md note is now wrong); review other useful hooks
- [x] **3.17** Ghostty trial — `.config/ghostty/config` tracked; font + theme parity with kitty; remote-control socket gap noted (no ghostty equivalent yet — keep kitty if that workflow gets kicked off)
- [x] **3.18** git-lfs — added to Brewfile under dev tools

### Phase 4: morsel

- [ ] **4.1** Replace starship Python morse code block with `morsel` CLI calls
- [ ] **4.2** Polish

### Phase 5: aloha

- [ ] **5.1** Replace zsh login/logout message with `aloha` CLI calls
- [ ] **5.2** Polish

### Phase 6: neopager

- [ ] **6.1** Replace `page` + neovim pager with `neopager`
- [ ] **6.2** Polish

### Phase 7: pangram

- [ ] **7.1** Build `pangram` Rust CLI (separate repo)
- [ ] **7.2** Polish — wire any dotfile integration that emerges

---

## Planned TUI tools

### morsel

Morse code tutor and conversion swiss pocket knife. Will replace the inline Python in `starship.toml`'s `custom.anchor` module. Separate repo. See `working/morsel-design-notes.md` for design notes.

### aloha

TUI for shell dashboards. Can be used interactively or in one shot. Use cases include interactive dashboards, login/logout messages, prompt sections, and more. Will use `.zlogin`, `.zlogout`, and `zshexit()` functions. Separate repo. See `working/zshrc-exit-ideas.txt` for design notes.

### neopager

A from-scratch pager built in Rust. Intended to replace `page` (which wraps neovim) with a standalone binary that has no neovim dependency but keeps the same UX contract: syntax highlighting, vi keys, and the ability to act as a drop-in for less/man/more. Alternatively, integrates with neovim in headless mode. Separate repo. See `working/NEOPAGER-PRD.md` for design notes.

### pangram

A Rust CLI for working with pangrams ("the quick brown fox..."). Modes:

- `pangram render <font>` — render the pangram in any installed font (sample sheet for typography work)
- `pangram type` — typing-practice mode, WPM + accuracy, picks a pangram by language/length
- `pangram info <id|"text">` — metadata: length, origin, popularity, language, era, use cases, explanation
- `pangram list` — browse pangram collection, filter by language / character set / length
- `pangram random` — random pangram for prompt blocks or shell startup messages

Drawing inspiration from the npm `pangram` and `is-pangram` packages (mostly: collections + validation), then extending: typography preview, typing practice, and metadata-rich exploration. Separate repo. Design notes to land in `working/PANGRAM-PRD.md` when work starts.

---

## Appendix: mini.nvim plugin tracker

> All plugins from the [nvim-mini](https://github.com/nvim-mini/mini.nvim) ecosystem. Decisions made here inform phase 4.3 (full audit).

### Status legend

`IN` = Installed | `SKIP` = Decided against | `RIVAL` = Using a better alternative | `REVIEW` = Not yet evaluated

### Installed

| Plugin            | Purpose                                    | Notes                                                                    |
| ----------------- | ------------------------------------------ | ------------------------------------------------------------------------ |
| mini.animate      | Animate scroll, cursor, window resize      | No strong rivals at this scope; terminal-level animation (kitty) is an alternative |
| mini.cmdline      | Command-line popup at cursor position      | vs noice.nvim — noice is heavy and frequently breaks; mini is the right call here |
| mini.cursorword   | Highlight all instances of word at cursor  | vs vim-illuminate — illuminate adds LSP reference support; revisit if LSP added |
| mini.indentscope  | Animate and highlight current indent scope | Complements ibl (static all-levels); indentscope = animated current scope only |
| mini.jump         | Enhanced f/t motions with visual targets   | No compelling alternative at this scope                                  |
| mini.starter      | Customisable start screen                  | vs dashboard-nvim (slicker, used by LazyVim) and alpha-nvim (most customisable); mini fits zero-config ethos |
| mini.surround     | Operators for surrounding characters       | Replaces default `s`; sa/sd/sr for add/delete/replace                    |
| mini.tabline      | Open buffers as a tab bar                  | No strong rival that stays passive                                       |
| mini.trailspace   | Highlight trailing whitespace              | Passive by default — trim via `:lua MiniTrailspace.trim()`; consider autocmd on write |

### Decided against (using rival)

| Plugin          | Rival used                 | Reason                                                                   |
| --------------- | -------------------------- | ------------------------------------------------------------------------ |
| mini.comment    | Neovim 0.10 built-in `gc`  | Native `gc`/`gcc` operators make this redundant; removed                 |
| mini.diff       | gitsigns.nvim              | gitsigns has more features, wider adoption, and hunk navigation          |
| mini.pick       | fzf-lua                    | fzf-lua uses native fzf binary — faster, better preview, more familiar   |
| mini.statusline | lualine.nvim               | lualine has richer component ecosystem and themes                        |

### Not yet evaluated (phase 4.3)

| Plugin          | Purpose                                    | Notes                                                                    |
| --------------- | ------------------------------------------ | ------------------------------------------------------------------------ |
| mini.ai         | Extend built-in text objects               | High value — adds `a`/`i` for function args, brackets, custom patterns   |
| mini.align      | Align text interactively                   | Low urgency; useful for table editing                                    |
| mini.bracketed  | Jump to next/prev bracket-like targets     | May overlap with mini.jump; evaluate together                            |
| mini.bufremove  | Delete buffer without closing window       | Useful when using splits; `<C-q>` currently does `bd` which closes window |
| mini.clue       | Show key binding hints after delay         | vs which-key.nvim; lower priority given `<leader>?` already exists       |
| mini.files      | File manager (floating window)             | SKIP — floating UI not preferred (per phase 4.5 decision)               |
| mini.hipatterns | Highlight arbitrary text patterns          | Could replace custom highlight autocmds                                  |
| mini.icons      | Unified icon provider                      | SKIP — adds visual noise; not needed for this setup                      |
| mini.map        | Scrollbar / minimap in sign column         | Nice to have; low priority                                               |
| mini.move       | Move selections and lines                  | Quality-of-life; evaluate alongside visual mode workflow                 |
| mini.notify     | Notification popups                        | vs noice.nvim; mini is the lighter option                                |
| mini.operators  | Additional operators (multiply, sort, etc) | Useful; evaluate with mini.ai as a pair                                  |
| mini.pairs      | Auto-close brackets and quotes             | vs nvim-autopairs; evaluate — current setup has no auto-pairs at all     |
| mini.sessions   | Session save and restore                   | Low priority; not a session-based workflow                               |
| mini.snippets   | Snippet expansion                          | Low priority without LSP                                                 |
| mini.splitjoin  | Split/join function arguments              | High value for code editing; evaluate                                    |
| mini.visits     | Track and jump to recent files             | May overlap with fzf-lua oldfiles; evaluate                              |

### Not applicable

| Plugin    | Reason                                            |
| --------- | ------------------------------------------------- |
| mini.deps | We use lazy.nvim                                  |
| mini.base16 / mini.colors / mini.hues | Colorscheme tooling; we use kanagawa |
| mini.doc  | Documentation generator for plugin authors        |
| mini.test | Testing framework for plugin authors              |
| mini.fuzzy | Underlying fuzzy matching library for mini.pick  |
| mini.extra | Extra sources/pickers for mini.pick              |
