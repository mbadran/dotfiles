# dotfiles

```
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
```

curated cli/tui configs and replacements. some things may be useful.

## stats

| stat                          | value     |
| ----------------------------- | --------- |
| first commit                  | 2011      |
| lines of config               | ~2,000    |
| vim burnouts                  | 1         |
| vim themes                    | 1         |
| vim plugins                   | 16        |
| vim mappings                  | 22        |
| tools replaced                | 13        |
| aliases defined               | 22        |
| homebrew formulae             | 47        |
| homebrew casks                | 43        |
| defaults optimised            | ongoing   |
| efficiencies gained           | debatable |

## what's in here

`$TERMINAL` — kitty. minimal config. remote control enabled for stream deck.

`$SHELL` — zsh with vi-mode, syntax highlighting, autosuggestions, and history
search. compinit cached daily. startup profiled on demand.

`$PROMPT` — starship with barista, a custom theme inspired by catppuccin. two-
line layout: left prompt for essentials (directory, git, shell), right prompt
for context (languages, status, time, a morse code experiment).

`$PAGER` — page via neovim for syntax highlighting, vim keybindings, and more.
three distinct pager profiles: direct (default), pipe/redirect/named, and man.
different themes/configs per profile.

`$TUI` — eza (ls), bat (cat), page (less/man/more), dust (du), ripgrep (grep),
fd (find), zoxide (cd), fzf (fuzzy everything), btop (top), delta (diff).

`$EDITOR` — post-burnout neovim config. (recovering vim-tragic here.)
minimal, portable, opinionated, and tinker-proof. no inessentials or ide
shenanigans. 1 theme, 16 plugins (mini.nvim ecosystem), 22 mappings. every
line earns its keep.

`$HOMEBREW` — declarative brewfile for reproducible mac setup. brew bundle for
fresh installs, brew upgrade --greedy to stay current.

`$AI` — ccstatusline for powerline-style statusline in claude code sessions.

`$LEGACY` — bash configs from 2011–2020. here be dragons. kept for the
(increasingly rare) server without zsh. lives under `.config/retired/bash/`.
