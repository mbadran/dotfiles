######################################################################## aliases

# avoid mistakes
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# supercharge ls
alias ls='ls -GF'
alias ll='ls -lahGF'
alias lt='ls -lahrtGF'

# use neovim by default
alias vim='/usr/local/bin/nvim'

# colourise grep by default
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

################################################################## auto-complete

# enable default completions
autoload -Uz compinit && compinit

# enable git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# search history backwards with ctrl-r
# bindkey '^r' history-incremental-search-backward

########################################################################### misc

# enable vi keybindings and kill the delay
bindkey -v
export KEYTIMEOUT=1

# enable starship
eval "$(starship init zsh)"
