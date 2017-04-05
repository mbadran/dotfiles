# everything here is only run once, on login

# include local binaries in the path
export PATH=/usr/local/bin:$PATH

# include pip binaries in the path (mac)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH=$HOME/Library/Python/2.7/bin:$PATH
fi

# customise ls colours
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [ -x /usr/bin/dircolors ]; then
        test -r $HOME/.dir_colors && eval "$(dircolors -b $HOME/.dir_colors)" || eval "$(dircolors -b)"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export LSCOLORS="gxfxcxdxbxegedabagacad"
    # export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"
fi

# add private keys to ssh-agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add $HOME/.ssh/overip
  ssh-add $HOME/.ssh/mbadran-bl
fi

# use vim instead of less
# FIXME: install on ubuntu or mac first (via ansible)
# https://github.com/rkitover/vimpager
# export PAGER=/usr/local/bin/vimpager

# java (mac)
# export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home/'

# golang
# export GOPATH=$HOME/Documents/go
# export GOROOT=/usr/local/opt/go/libexec
# export PATH=$PATH:$GOPATH/bin
# export PATH=$PATH:$GOROOT/bin

# include .bashrc if it exists
# this should always be the last thing in this file
if [ -f "$HOME/.bashrc" ]; then
source "$HOME/.bashrc"
fi


