################################################################### zsh settings

# enable brew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# enable default completions
autoload -Uz compinit && compinit

# enable case-insensitive completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# search history backwards with ctrl-r (like bash)
bindkey '^r' history-incremental-search-backward

# replaced with vi-mode plugin (below)
# enable vi keybindings (and kill the delay)
# bindkey -v
# export KEYTIMEOUT=1

#################################################################### zsh plugins

# enable vi-mode
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# activate additional completions
fpath=($(brew --prefix)/share/zsh-completions $fpath)

# activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# activate auto suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# activate history search
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

######################################################################## helpers

# nodejs helpers
alias cy='npm run test:open'
alias cyd='npm run test:dev'
alias cyci='npm run test:ci'
alias cyls='npm run test:list --silent'

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

# replace cd with zoxide
alias cd=z
eval "$(zoxide init zsh)"

# replace cat with bat
alias cat="bat --style=plain --paging=never"    # aka bat -pp

# replace pagers with bat
export PAGER=bat
alias more=bat
alias less="bat --paging=always"
# alias zless=bat       # for archives TODO: fix

# replace man with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'" 
# export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# replace du with dust
alias du=dust

# replace grep with ripgrep
alias grep=rg

# replace find with fd
alias find=fd

# replace top with btop
alias top=btop

# replace vim with neovim
alias vi=nvim
alias vim=nvim

# use fuzzy search
# (sets up fzf key bindings and fuzzy completion)
eval "$(fzf --zsh)"

# replace default prompt with starship
eval "$(starship init zsh)"

########################################################################## fixes

# alacritty
# fix terminal window title
# before every command: set title to just the command/process name
preexec() {
  print -Pn "\e]0;${1%% *}\a"
}
# when returning to prompt: set title to 'zsh'
precmd() {
  print -Pn "\e]0;zsh\a"
}

####################################################################### lmstudio

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mo/.lmstudio/bin"
# End of LM Studio CLI section
