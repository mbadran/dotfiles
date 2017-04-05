# avoid mistakes
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# long list
alias ll='ls -lahF'

# recursive long list
alias lt='ls -lahrtF'

# colourise ls by default
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias ls='ls --color'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
fi

# push and pop
alias pu='pushd $* > /dev/null'
alias po='popd > /dev/null'

# colourise grep by default
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# use neovim by default
alias vim='nvim'

# tools
alias myip='curl http://wtfismyip.com/text'

# show disk usage
alias usage='du -ak|sort -nr|less'
alias hog='du -gs * | sort -nr'
# FIXME (argument)
alias dutotal='du -ch $1 | tail -1'

# FIXME
# rm to mac trash instead of deleting
# http://hintsforums.macworld.com/archive/index.php/t-9123.html
# alias rm='mv \!* ~/.Trash/'

