################################################################### path updates

export PATH="$PATH:$HOME/.local/bin"

###################################################################### profiling
# usage: ZSH_PROFILE=1 zsh -i -c exit
# logs:  ./logs/zsh-profile-*.log (gitignored)

DOTFILES_DIR="${0:A:h}"
ZSH_LOG_DIR="${ZSH_LOG_DIR:-${DOTFILES_DIR}/logs}"

if [[ "$ZSH_PROFILE" == "1" ]]; then
  zmodload zsh/zprof
  zmodload zsh/datetime
  _zsh_start=$EPOCHREALTIME
fi

################################################################### zsh settings

# cache brew prefix (called many times below — avoid repeated subprocess forks)
_brew_prefix=$(brew --prefix)

# enable brew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
  FPATH=${_brew_prefix}/share/zsh/site-functions:$FPATH
fi

# enable default completions
# FIXME: compinit is slow (~80-120ms) — cache with daily rebuild in phase 2
autoload -Uz compinit && compinit

# enable case-insensitive completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY                    # share across sessions
setopt HIST_IGNORE_ALL_DUPS             # no duplicates
setopt HIST_REDUCE_BLANKS               # trim whitespace

# search history backwards with ctrl-r (like bash)
bindkey '^r' history-incremental-search-backward

# remove the 1-character gap on the right of the prompt
export ZLE_RPROMPT_INDENT=0

#################################################################### zsh plugins

# enable vi-mode
source ${_brew_prefix}/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# activate additional completions
fpath=(${_brew_prefix}/share/zsh-completions $fpath)

# activate syntax highlighting
source ${_brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# activate auto suggestions
source ${_brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# activate history search
source ${_brew_prefix}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

################################################################### tui upgrades

# avoid mistakes
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# replace ls with eza
alias ls=eza
alias ll="eza --all --long --icons --git"

# replace tree with eza
alias tree="eza -T"

# replace cd with zoxide (--cmd cd replaces cd with a smart function
# that uses zoxide interactively but falls back to builtin cd in scripts)
eval "$(zoxide init zsh --cmd cd)"

# replace cat with bat
alias cat="bat --style=plain --paging=never"    # aka bat -pp

# replace pagers with bat
export PAGER=bat
alias more=bat
alias less="bat --paging=always"

# replace man with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# replace du with dust
alias du=dust

# replace grep with ripgrep
alias grep=rg

# replace find with fd
alias find=fd

# replace top with btop
alias top=btop

# replace vim with neovim
export EDITOR=nvim
export VISUAL=nvim
alias vi=nvim
alias vim=nvim

# replace diff with delta
alias diff=delta

# use fuzzy search
# (sets up fzf key bindings and fuzzy completion)
eval "$(fzf --zsh)"

# replace default prompt with starship
eval "$(starship init zsh)"

################################################################### misc aliases

# nodejs helpers
alias cy='npm run test:open'
alias cyd='npm run test:dev'
alias cyci='npm run test:ci'
alias cyls='npm run test:list --silent'

######################################################################### logout
# login/logout: handled by .zlogin / .zlogout / exit TUI (WIP)
# see working/zshrc-exit-ideas.txt for design notes

################################################################ profiling (end)
# NOTE: this block must stay below all other config — it captures total
# startup time. apps that auto-append config (eg. lmstudio) will land
# below this, so move them above manually after they're added.

if [[ "$ZSH_PROFILE" == "1" ]]; then
  _zsh_end=$EPOCHREALTIME
  _zsh_elapsed=$(( (_zsh_end - _zsh_start) * 1000 ))
  mkdir -p "$ZSH_LOG_DIR"
  _logfile="${ZSH_LOG_DIR}/zsh-profile-$(date +%Y%m%d-%H%M%S).log"
  {
    echo "=== zsh startup profile ==="
    echo "date: $(date -Iseconds)"
    printf "elapsed: %.0fms\n" "$_zsh_elapsed"
    echo ""
    zprof
  } > "$_logfile"
  printf "profiled in %.0fms → %s\n" "$_zsh_elapsed" "$_logfile"
fi

############################################################# app customisations
# NOTE: apps often auto-append config to the end of .zshrc.
# after installing a new app, move its config above profiling (end).

### lmstudio ###################################################################

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mb/.lmstudio/bin"
# End of LM Studio CLI section

### claude #####################################################################

export DISABLE_AUTOUPDATER=1

### qqwing #####################################################################

alias qqwing='docker run --rm -i qqwing'
