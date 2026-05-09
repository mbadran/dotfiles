# testing guide

Verification checklists for dotfiles changes. The goal is not to break the shell.

## before any commit

- [ ] `git diff --stat` -- review what's changing
- [ ] `git diff` -- read the actual diff

## starship

- [ ] Open a new terminal tab (don't just source -- starship caches)
- [ ] Left prompt renders: directory, git branch, git status, shell indicator
- [ ] Right prompt renders: time, OS icon, language versions (cd into a project)
- [ ] `cd` into a git repo -- branch/status segment appears
- [ ] `cd /tmp` -- git segments disappear cleanly
- [ ] `starship explain` -- all modules recognised

### docker context

**[docker_context]** — requires a docker file in cwd (`only_with_files = true`). Test from any dir with a `Dockerfile`: `export DOCKER_HOST=test` — segment appears immediately. Clear: `unset DOCKER_HOST`.

### package

**[package]** — `cd working/test-starship/` — right prompt shows version from `package.json` (1.2.3). To test Cargo.toml detection: temporarily rename `package.json` and add a `Cargo.toml` with `[package]\nversion = "0.4.2"`.

### language modules

**[conda]** — `export CONDA_DEFAULT_ENV=base` in current shell, then open new tab — right prompt shows conda segment. Clear: `unset CONDA_DEFAULT_ENV`.

## zsh

- [ ] Open a new terminal tab -- clean startup, no errors
- [ ] `readlink ~/.zshenv` → `.config/zsh/.zshenv` (relative symlink, chains via `~/.config`)
- [ ] `echo $ZDOTDIR` → `~/.config/zsh`
- [ ] `echo $XDG_DATA_HOME` → `~/.local/share`, `$XDG_CACHE_HOME` → `~/.cache`
- [ ] `echo $HISTFILE` → `~/.local/share/zsh/history` (NOT `~/.config/zsh/.zsh_history`)
- [ ] `echo $SHELL_SESSION_DIR` → `~/.local/share/zsh/sessions`
- [ ] No stale state: `ls ~/.config/zsh/.zsh_history` and `~/.config/zsh/.zsh_sessions` both empty
- [ ] Test core aliases: `ls`, `ll`, `cat`, `grep`, `find`, `top`, `vim`, `cd`, `tree`
- [ ] Test vim mode: `Esc`, then `k`/`j` for history; `v` to edit current command in nvim
- [ ] Test fzf: `Ctrl-R` (history), `Ctrl-T` (files)
- [ ] Test fzf-tab: type `git ` and press tab — fzf-driven menu appears
- [ ] Test tab completion with partial command — grouped by category, bold headers
- [ ] Test new history opts: prefix command with space → not saved to history
- [ ] Antidote bundle present: `ls ~/.config/zsh/.zsh_plugins.zsh` (gitignored, regenerated as needed)

## ghostty

- [ ] `ghostty +validate-config` returns no errors and no output (run after every config edit and after `brew upgrade ghostty`)
- [ ] `ghostty +show-config | grep -E '^(theme|font-family|font-size|background)'` resolves expected values (theme name = canonical bundled name, e.g. `Catppuccin Macchiato` not kebab-case; font family resolves to a real face per `+list-fonts`)
- [ ] `ghostty` opens — IosevkaTerm NFM 20pt, Catppuccin Macchiato theme
- [ ] No remote-control socket parity yet (kitty still required for Stream Deck)
- [ ] Note: ghostty's vocabulary diverges from kitty's (theme casing, font face naming). Don't translate values blindly — validate on each side.

## claude code

- [ ] `readlink ~/.claude/settings.json` → `../.config/claude/settings.json`
- [ ] `~/.claude/settings.local.json` exists (untracked, host-local cc-beeper hooks)
- [ ] Open a Claude session in any project — SessionStart hook prints recap (branch, drift, memory, decay candidates)
- [ ] Open Claude in dotfiles repo — local `scripts/agents/start.sh` invoked at the bottom of the recap
- [ ] On session close — SessionEnd hook prints drift summary + push reminder, then runs local end.sh if present
- [ ] Permissions test: `git push` prompts even in dotfiles (project allows commit/add but not push — global ask wins)

## profiling

- [ ] Set `ZSH_PROFILE=1` in `.zshrc`, open a new shell -- banner with elapsed time and log path
- [ ] Check log: `cat logs/zsh-profile-*.log`
- [ ] Set `ZSH_PROFILE=0` -- no profiling output, no overhead

## page

- [ ] `less README.md` -- opens in page with habamax colorscheme, relative numbers, cursorline
- [ ] `man ls` -- opens with man filetype syntax highlighting
- [ ] `more README.md` -- prints inline if fits, opens page only if longer than screen
- [ ] `echo "test" | less` -- piped input works
- [ ] `page README.md` -- file view mode, retrobox colorscheme
- [ ] `logf somefile` -- follow mode, content streams in

## ccstatusline

- [ ] `ccsl` -- runs without error, prints usage or version
- [ ] Claude Code statusline renders correctly in the terminal

## kitty

- [ ] Open kitty -- no errors or warnings in startup
- [ ] Remote control socket active: `ls /tmp/kitty.sock` -- file exists
- [ ] Remote control works: `kitty @ --to unix:/tmp/kitty.sock ls` -- returns window list

## homebrew

- [ ] `source ~/.config/brew/brew.env` -- sets `HOMEBREW_BUNDLE_FILE` correctly
- [ ] `echo $HOMEBREW_BUNDLE_FILE` -- points to `.config/brew/Brewfile`
- [ ] New terminal tab -- `brew` available (shellenv sourced from .zprofile)
- [ ] `python3 scripts/brew/sync.py` -- prints "Brewfile in sync" (or applied drift output) without errors
- [ ] After `brew install <pkg>`: next session start (or manual sync run) auto-appends `<pkg>` to the `uncategorized` Brewfile section with description from `brew info`
- [ ] After `brew uninstall <pkg>`: next session sync removes `<pkg>` from Brewfile (gated by `.config/brew/.installed.lock` so first-clone runs don't wipe)
- [ ] Commented entries (e.g. `# cask "ovim"`) are reported as "skipped (commented in Brewfile)" and left alone

## btop

- [ ] `btop` -- opens with theme background visible (not transparent/16-colour TTY mode)
- [ ] `force_tty = false` -- keeps full-colour theme rendering; `theme_background = true` -- shows the theme's main_bg
- [ ] After theme change via UI: btop rewrites the file with verbose `#*` doc comments + cellar-versioned theme path. Expected — don't fight it.

## zellij

- [ ] `zellij` -- opens with default config (no errors, status bar at top)
- [ ] `Ctrl-q` quits cleanly
- [ ] Default keymap modes work (`Ctrl-p` panes, `Ctrl-t` tabs, etc.)
- [ ] `~/.config/zellij/config.kdl` is the live config (no override surprise from `~/.zellij/config.kdl`)

## lm studio (XDG relocation)

- [ ] `ls -la ~/.config/lmstudio/` -- shows symlinks for `models`, `extensions`, `bin`, `.internal`, `server-logs`, `conversations`, `hub`, `working-directories`, `user-files`, `config-presets`, `credentials`, `projects` -- all pointing to `~/.local/share/lmstudio/<name>`
- [ ] `ls -la ~/.local/share/lmstudio/` -- the heavy data lives here (~11G)
- [ ] `du -sh ~/Documents/projects/dotfiles/.config/lmstudio` -- 8K (just `settings.json` + `mcp.json` + 12 symlinks)
- [ ] LM Studio app opens, sees its models, can chat -- proves symlinks are resolving correctly
- [ ] If LM Studio ever recreates one of the heavy dirs as a real dir (not symlink): symlink got unlinked; redo the move for that dir + investigate

## splashboard

- [ ] `cd ~` -- splashboard renders with home dashboard layout
- [ ] `cd` into a project dir -- splashboard renders project layout (commits, PRs, issues)
- [ ] If `GH_TOKEN` is unset: splashboard surfaces a clear "missing token" error (PRD 3.23)
- [ ] `~/.config/splashboard/cache/` is gitignored (lots of `<source>-<hash>.json` files; safe to delete, regenerates)

## claudebar

- [ ] `claudebar` runs as menu-bar app -- shows Claude Code session usage
- [ ] `~/.config/claudebar/settings.json` is the live config (only file tracked from this dir)

## neovim

- [ ] `nvim` -- opens with kanagawa-dragon theme, mini.starter screen, no errors
- [ ] `:Lazy` -- all plugins installed and up to date
- [ ] `<C-p>` -- fzf-lua file picker opens
- [ ] `<C-t>` -- fzf-lua live grep opens
- [ ] `<C-h>` / `<C-l>` -- prev/next buffer navigation
- [ ] `<C-n>` -- new empty buffer opens
- [ ] `<C-b>` -- netrw file explorer toggles
- [ ] `<leader>?` -- shows all ♠ custom mappings
- [ ] Open a file -- mini.tabline shows buffer tab bar
- [ ] Type trailing spaces -- mini.trailspace highlights them
- [ ] Scroll a long file -- mini.animate scroll animation visible
- [ ] Move cursor over a word -- mini.cursorword highlights other instances
- [ ] `:` -- mini.cmdline appears at cursor position, not bottom bar
- [ ] `sa(` on a word -- mini.surround wraps in parens
- [ ] `gc` on a line -- built-in commenting toggles (no mini.comment)

## macmon

- [ ] `macmon` -- TUI opens with sparkline view, green color, 1s refresh

## git

- [ ] `git status` -- only expected files
- [ ] No secrets staged (.env, hosts.yml, tokens, etc.)
