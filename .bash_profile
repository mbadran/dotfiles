# everything here is only run once, on login

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
    # export LSCOLORS="gxfxcxdxbxegedabagacad"
    export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"
fi

# TODO: check - do i need this when i log in / restart laptop?
# and if so, do i need the -K flag?
#
# add private keys to ssh-agent and store passphrase
# https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
# if [ -z "$SSH_AUTH_SOCK" ] ; then
#     eval "$(ssh-agent -s)"
#     ssh-add -K $HOME/.ssh/keys/doubleplus/mo_phoenix.pem
# fi

# use vimpager instead of less (mac)
# note that it needs to be installed via brew first
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PAGER=/usr/local/bin/vimpager
fi

# include .bashrc if it exists
# this should always be the last thing in this file
if [ -f "$HOME/.bashrc" ]; then
     source "$HOME/.bashrc"
fi

# include .bash_login if it exists
# this should always be the last thing in this file
if [ -f "$HOME/.bash_login" ]; then
     source "$HOME/.bash_login"
fi

