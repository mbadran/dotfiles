########################################################################### todo
# - fix ls colours
# - fix ls autocomplete colours (and make them the same as ls colours)

####################################################################### settings

# enable brew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# enable default completions
autoload -Uz compinit && compinit

# enable case-insensitive completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# enable vi keybindings (and kill the delay)
bindkey -v
export KEYTIMEOUT=1

# use vimpager instead of less
export PAGER=vimpager
alias less=$PAGER
alias zless=$PAGER

# search history backwards with ctrl-r (like bash)
bindkey '^r' history-incremental-search-backward

#################################################################### zsh plugins

# activate additional completions
fpath=(/usr/local/share/zsh-completions $fpath)

# activate syntax highlighting
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# activate auto suggestions
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# activate history search
# source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

######################################################################## aliases

# avoid mistakes
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# improve ls
alias ls='ls -GF'
alias ll='ls -lahGF'
alias lt='ls -lahrtGF'

# use neovim instead of vim
alias vi='/opt/homebrew/bin/nvim'
alias vim='/opt/homebrew/bin/nvim'

# colourise grep by default
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

######################################################################### prompt

eval "$(starship init zsh)"
