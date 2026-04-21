# dotfiles

```
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
```

curated cli/tui configs and replacements. some things may be useful, but
no promises.

## stats

| stat                          | value     |
| ----------------------------- | --------- |
| first commit                  | 2011      |
| lines of config               | ~1,800    |
| vim burnouts                  | 1         |
| vim themes                    | 1         |
| vim plugins                   | 8         |
| vim mappings                  | 18        |
| tools replaced                | 13        |
| aliases defined               | 22        |
| homebrew formulae             | 42        |
| homebrew casks                | 46        |
| defaults optimised            | ongoing   |
| efficiencies gained           | debatable |

## what's in here

`$EDITOR` — post-burnout neovim config. (recovering vim-tragic here.)
minimal, portable, opinionated, and tinker-proof. no inessentials or ide
shenanigans. 1 theme, <=10 plugins, <=20 mappings. every line earns its keep.

`$TERMINAL` — kitty. minimal config. remote control enabled for stream deck.

`$SHELL` — zsh with vi-mode, syntax highlighting, autosuggestions, and history
search. compinit cached daily. startup profiled on demand.

`$PROMPT` — starship with barista, a custom theme inspired by catppuccin. two-
line layout: left prompt for essentials (directory, git, shell), right prompt
for context (languages, status, time, a morse code experiment).

`$PAGER` — page via nvimpager. neovim as pager: syntax highlighting, vi keys,
habamax theme. aliases wired to less, man, and more in zshrc.

`$TUI` — eza (ls), bat (cat), page (less/man/more), dust (du), ripgrep (grep),
fd (find), zoxide (cd), fzf (fuzzy everything), btop (top), delta (diff).

`$HOMEBREW` — declarative Brewfile for reproducible mac setup. 42 formulae,
46 casks, 3 custom taps. brew bundle for fresh installs, brew upgrade --greedy
to stay current.

`$CLAUDE` — ccstatusline: powerline statusline for claude code sessions.
claude settings and hooks coming in phase 3.

`$LEGACY` — bash configs from 2011–2020. here be dragons. kept for the
(increasingly rare) server without zsh.
