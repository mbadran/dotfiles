# Testing Guide

Verification checklists for dotfiles changes. The goal is not to break the shell.

## Before Any Commit

- [ ] `git diff --stat` -- review what's changing
- [ ] `git diff` -- read the actual diff for anything unexpected

## Starship

- [ ] Open a new terminal tab (don't just source -- starship caches)
- [ ] Verify left prompt renders: directory, git branch, git status, shell indicator
- [ ] Verify right prompt renders: time, OS icon, language versions (cd into a project)
- [ ] `starship explain` -- confirms all modules are recognised and configured
- [ ] `cd` into a git repo and check branch/status segment
- [ ] `cd` into a node/rust/python project and check language segment on right
- [ ] Check that the morse code tutor shows on the right prompt

## Zsh

- [ ] `source ~/.zshrc` in current tab -- no errors or warnings
- [ ] Open a new terminal tab -- clean startup, no errors
- [ ] Test core aliases: `ls`, `ll`, `cat`, `grep`, `find`, `top`, `vim`, `cd`, `tree`
- [ ] Test vim mode: press `Esc`, then `k`/`j` for history search
- [ ] Test `fzf`: `Ctrl-R` for history search, `Ctrl-T` for file search
- [ ] Test tab completion: type partial command + `Tab`

## Profiling

- [ ] `ZSH_PROFILE=1 zsh -i -c exit` -- should print elapsed time and log path
- [ ] `ls logs/` -- confirm a timestamped log file was created
- [ ] `cat logs/zsh-profile-*.log` -- confirm it has elapsed time + zprof output
- [ ] Normal shell (without ZSH_PROFILE) -- no profiling output, no overhead

## Git State

- [ ] `git status` -- only expected files modified/added
- [ ] No secrets or credentials staged (.env, hosts.yml, tokens, etc.)
- [ ] `git log --oneline -5` -- commit messages are descriptive
