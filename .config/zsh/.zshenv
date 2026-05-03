###################################################### zdotdir (zsh config home)

# zsh reads .zshenv from $HOME on startup (ZDOTDIR is unset at that point),
# so $HOME/.zshenv MUST be a symlink to this file. After setting ZDOTDIR
# below, zsh uses it for every other startup file (.zshrc, .zprofile, etc.).

export ZDOTDIR=$HOME/.config/zsh

###################################### xdg base dirs (scope: shell & subprocess)

# .zshenv runs for EVERY zsh invocation (including non-interactive scripts),
# so put env that should be visible system-wide here, not in .zshrc.

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ensure the dirs exist
mkdir -p "$XDG_BIN_HOME" "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

################################################ macos shell-session integration

# /etc/zshrc_Apple_Terminal (and Ghostty's equivalent) write per-session
# state files. Default is $ZDOTDIR/.zsh_sessions when ZDOTDIR is set —
# redirect it into XDG_DATA_HOME. Must be exported before /etc/zshrc runs,
# which is why it lives here and not in .zshrc.

export SHELL_SESSION_DIR="$XDG_DATA_HOME/zsh/sessions"

# ensure the dir exists
mkdir -p "$SHELL_SESSION_DIR"
