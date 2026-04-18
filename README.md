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

| | |
|-|-|
| first commit | 2011 |
| lines of config | ~2,200 |
| vim burnouts | 1 |
| vim themes | 1 |
| vim plugins | 7 |
| vim mappings | 15 |
| tools replaced | 13 |
| aliases defined | 22 |
| defaults exterminated | ongoing |
| morse code characters learned | debatable |

## what's in here

`$EDITOR` — post-burnout neovim config. (recovering vim-tragic here.)
minimal, portable, opinionated, and tinker-proof. no inessentials or ide
shenanigans. 1 theme, <=10 plugins, <=20 mappings. every line earns its keep.

`$SHELL` — zsh with vi-mode, syntax highlighting, autosuggestions, history
search. compinit cached daily. startup profiled on demand.

`$PROMPT` — starship with barista, a custom theme inspired by catppuccin. two-
line layout: left prompt for essentials (directory, git, shell), right prompt
for context (languages, status, time, a morse code experiment).

`$TERMINAL` — kitty. 9 lines of config. (wip)

`$TUI` — eza (ls), bat (cat), nvimpager (less/man/more), dust (du), ripgrep (grep), fd (find),
zoxide (cd), fzf (fuzzy everything), btop (top), delta (diff).

`$LEGACY` — bash configs from 2011–2020. here be dragons. kept for the
increasingly rare server without zsh.
