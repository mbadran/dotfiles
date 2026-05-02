###################################### xdg base dirs (scope: shell & subprocess)

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ensure the dirs exist
mkdir -p "$XDG_BIN_HOME" "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

############################## zsh base dirs (immutable/protected, scope: shell)

readonly ZCOMPCACHE="$XDG_CACHE_HOME/zsh/.zcompcache"  # completion cache file
readonly ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"    # completion dump file
readonly ZSH_HISTORY="$XDG_DATA_HOME/zsh/history"      # zsh history file
readonly ZSH_LOG_DIR="$XDG_DATA_HOME/zsh/logs"         # zsh profiling logs

# ensure the zsh subdirs exist
mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_DATA_HOME/zsh"

########################################################## zsh profiling (start)

# uses zprof to measure total zsh startup time with breakdown per-function
# to run, turn profiling on and run a sub shell, then check $ZSH_LOG_DIR
# `$ ZSH_PROFILING=1 zsh`

ZSH_PROFILING=${ZSH_PROFILING:-0}

if (( ZSH_PROFILING )); then
  zmodload zsh/zprof                    # per-function call profiler
  zmodload zsh/datetime                 # high-precision $EPOCHREALTIME
  _zsh_start=$EPOCHREALTIME
fi

################################################################### path updates

typeset -U path fpath                 # prevent duplicate entries
path=("$XDG_BIN_HOME" $path)          # include xdg bin in path

################################################################### zsh settings

# remove the 1-character gap on the right of the prompt
export ZLE_RPROMPT_INDENT=0

# allow # comments in interactive shells (paste-friendly)
setopt INTERACTIVE_COMMENTS

# typo correction prompt (remove if it gets annoying)
setopt CORRECT

# every cd pushes onto the dir stack; `cd -<n>` to jump back
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# treat /, ., - as word boundaries for ctrl-w / ctrl-left
WORDCHARS=''

# improve history
HISTFILE=$ZSH_HISTORY
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY                    # share across sessions
setopt EXTENDED_HISTORY                 # store timestamp + duration
setopt HIST_IGNORE_ALL_DUPS             # no duplicates
setopt HIST_IGNORE_SPACE                # leading space hides command from history
setopt HIST_REDUCE_BLANKS               # trim whitespace
setopt HIST_VERIFY                      # !history expansion shows before running
setopt HIST_FIND_NO_DUPS                # skip duplicates when searching

# search history backwards with ctrl-r (like bash)
bindkey '^r' history-incremental-search-backward

################################################################ zsh completions

# enable brew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
  fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
fi

# activate additional completions
fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)

# enable completions (lazy loaded from cache, when needed)
autoload -Uz compinit

# rebuild completion cache every day
if [[ -n "$ZCOMPDUMP"(#qN.mh+24) ]]; then
  compinit -d "$ZCOMPDUMP"
else
  compinit -C -d "$ZCOMPDUMP"
fi

# use completion by default
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZCOMPCACHE"

# enable case-insensitive completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# arrow-key menu for completions
zstyle ':completion:*' menu select

#################################################################### zsh plugins

# antidote — sources plugins listed in .zsh_plugins.txt via a generated bundle
# manifest: $ZDOTDIR/.zsh_plugins.txt   (tracked)
# bundle:   $ZDOTDIR/.zsh_plugins.zsh   (gitignored, regenerated when manifest changes)
source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh
antidote load

# bindings for zsh-history-substring-search (loaded via antidote)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

######################################################################### logout

# TODO: login/logout: handled by .zlogin / .zlogout / exit TUI (WIP)
# see working/zshrc-exit-ideas.txt for design notes

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

# replace cat with bat
alias cat="bat --style=plain --paging=never"    # aka bat -pp

# replace pagers and viewers with page
export PAGER='page -W -q -P'
export MANPAGER='page -W -t man'
export PAGE_REDIRECTION_PROTECT=0  # always spawn fresh; disable redirect-into-existing-instance check

# replace more and less
more() { page -W -O -- "$@" }   # cat mode: inline if fits, skip neovim; function (not alias) to avoid -O consuming filename as its optional arg
alias less='page -W'            # file viewer (no -P: avoids PTY redirect mode)

# man with proper section handling (enables man://prog(N) URI navigation)
man() {
    local section="${@[-2]}"
    local program="${@[-1]}"
    page -W "man://$program${section:+($section)}"
}

# follow a file or stream (like tail -f but in neovim)
alias logf='page -W -f'

# name pager buffers after the command that produced them (zsh)
# also set the terminal window title to the running command
preexec() {
    local words=(${1%%[|>]*})    # strip from first | or > then word-split
    export PAGE_BUFFER_NAME="${words[1,2]}"
    export PAGE_PIPE_CMD="${1}"  # full typed command (used by page statusline)
    printf "\e]0;%s\e\\" "${1}"  # set title to full command (reset by precmd)
}

# reset terminal title to current directory after each command
precmd() {
    print -Pn "\e]0;%~\e\\"
}

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

############################################################# app customisations

# NOTE: apps often auto-append config to the end of .zshrc.
# after installing a new app, move its config above profiling (end).

### lmstudio ###################################################################
# Added by LM Studio CLI (lms)
path=("$HOME/.lmstudio/bin" $path)
# End of LM Studio CLI section

### claude #####################################################################
# auto update doesn't work with the homebrew cask
export DISABLE_AUTOUPDATER=1

### claude code statusline #####################################################
alias ccsl='npx -y ccstatusline@latest'

### nodejs helpers #############################################################
alias cy='npm run test:open'
alias cyd='npm run test:dev'
alias cyci='npm run test:ci'
alias cyls='npm run test:list --silent'

### qqwing #####################################################################
alias qqwing='docker run --rm -i qqwing'

### zoxide #####################################################################

# replace cd with zoxide (must init after all plugins and config)
eval "$(zoxide init zsh --cmd cd)"

############################################################ zsh profiling (end)

# note: this block must stay below all other config — it captures total startup
# time. apps that auto-append config (eg. lmstudio) will land below this, so
# move them above manually after they're added.

if (( ZSH_PROFILING )); then
  _zsh_end=$EPOCHREALTIME
  _zsh_elapsed=$(( (_zsh_end - _zsh_start) * 1000 ))
  mkdir -p "$ZSH_LOG_DIR"
  _logfile="${ZSH_LOG_DIR}/zsh-profiling_$(date +%Y%m%d-%H%M%S).log"
  {
    echo "=== zsh startup profile ==="
    echo "date:    $(date -Iseconds)"
    printf "elapsed: %.0fms\n" "$_zsh_elapsed"
    echo ""
    echo "--- per-function breakdown (zprof) ---"
    echo ""
    zprof
  } > "$_logfile"
  echo "\n─────────────────────────────────────────"
  printf "  Profiled zsh in %.0fms → %s\n" "$_zsh_elapsed" "$_logfile"
  echo "─────────────────────────────────────────"
fi
