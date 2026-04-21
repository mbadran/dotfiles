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

## zsh

- [ ] Open a new terminal tab -- clean startup, no errors
- [ ] Test core aliases: `ls`, `ll`, `cat`, `grep`, `find`, `top`, `vim`, `cd`, `tree`
- [ ] Test vim mode: `Esc`, then `k`/`j` for history
- [ ] Test fzf: `Ctrl-R` (history), `Ctrl-T` (files)
- [ ] Test tab completion with partial command

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

- [ ] `brew bundle check` -- no missing packages
- [ ] `source ~/.config/brew/brew.env` -- sets `HOMEBREW_BUNDLE_FILE` correctly
- [ ] `echo $HOMEBREW_BUNDLE_FILE` -- points to `.config/brew/Brewfile`
- [ ] `brew bundle check --verbose` -- all entries satisfied
- [ ] New terminal tab -- `brew` available (shellenv sourced from .zprofile)

## git

- [ ] `git status` -- only expected files
- [ ] No secrets staged (.env, hosts.yml, tokens, etc.)
