# avoid mistakes
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# FIXME
# http://hintsforums.macworld.com/archive/index.php/t-9123.html
# alias rm='mv \!* ~/.Trash/'

# tweaks
alias ls='ls --color'
alias ll='ls -lahF'
alias lt='ls -lahrtF'
#alias pu='pushd $* > /dev/null'
#alias po='popd > /dev/null'

# usage
alias usage='du -ak|sort -nr|less'
alias hog='du -gs * | sort -nr'
# FIXME (argument)
alias dutotal='du -ch $1 | tail -1'

# tools
alias myip='curl http://wtfismyip.com/text'
