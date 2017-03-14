# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# use vim instead of less
# TODO: install on ubuntu first (via ansible)
# https://github.com/rkitover/vimpager
# export PAGER=/usr/local/bin/vimpager

# include local binaries in the path
export PATH=/usr/local/bin:$PATH

# java (mac)
# export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home/'

# golang
# export GOPATH=$HOME/Documents/go
# export GOROOT=/usr/local/opt/go/libexec
# export PATH=$PATH:$GOPATH/bin
# export PATH=$PATH:$GOROOT/bin

# colorise ls (mac)
# if [ -f $HOME/.dir_colors ]; then
#   export LS_COLORS="gxfxcxdxbxegedabagacad"
# fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add ~/.ssh/mbadran-bl
fi
