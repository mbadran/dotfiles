######################################################################## general

# system-wide configs for all zsh invocations, including non-interactive scripts
# (which don't use .zshrc)
#
# everything here is a dependency before any other zsh files load
#
# set these configs system-wide by symlinking this file to /etc/zshenv,
# or per-user by symlinking to $HOME/.zshenv
#
# env var scope: all zsh shells (interactive & not) + any subprocesses

################################################################## xdg base dirs

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ensure the dirs exist
mkdir -p "$XDG_BIN_HOME" "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

################################################################ zsh config home

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
mkdir -p "$ZDOTDIR"

################################################ macos shell-session integration

# /etc/zshrc_Apple_Terminal (and other terminals) write state files per session
# save these in XDG_DATA_HOME instead of the default ($ZDOTDIR/.zsh_sessions)

export SHELL_SESSION_DIR="$XDG_DATA_HOME/zsh/sessions"
mkdir -p "$SHELL_SESSION_DIR"
