# dotfiles

██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝

curated cli/tui configs and replacements. some things may be useful, but
no promises.

## stats

| | |
|-|-|
| first commit | 2011 |
| lines of config | ~2200 |
| vim burnouts | 1 |
| vim themes | 1 |
| vim plugins | 7 |
| vim mappings | 15 |
| tools replaced | 13 |
| aliases defined | 21 |
| defaults exterminated | ongoing |
| morse code characters learned | debatable |

## what's in here

`$EDITOR` — post-burnout neovim config. (recovering vim-tragic here.)
minimal, portable, opinionated, and tinker-proof. no lsp, autocomplete, or ide
shenanigans. 1 theme, <=10 plugins, <=20 mappings. every line earns its keep.

`$SHELL` — zsh with vi-mode, syntax highlighting, autosuggestions, history
search. compinit cached daily. startup profiled on demand.

`$PROMPT` — starship with catppuccin macchiato powerline. two-line layout:
left prompt for essentials (directory, git, shell), right prompt for context
(languages, status, time, a morse code tutor of questionable utility).

`$TERMINAL` — kitty. 9 lines of config.

`$TUI` — eza (ls), bat (cat/less/man), dust (du), ripgrep (grep), fd (find),
zoxide (cd), fzf (fuzzy everything), btop (top), delta (diff).

`$LEGACY` — bash configs from 2011–2020. here be dragons. kept for the
increasingly rare server without zsh.
