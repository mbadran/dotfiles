# dotfiles

Mostly curated CLI/TUI replacements and config. There may be some things of
interest here, but no promises.

## stats

| | |
|-|-|
| first commit | 2011 |
| mass extinction of defaults | ongoing |
| vim plugins | 7 (hard limit: 10) |
| vim mappings | 15 (hard limit: 20) |
| vim themes | 1 (hard limit: 1) |
| tools replaced | 13 |
| aliases defined | 21 |
| lines of config | ~2200 |
| lines of kitty docs deleted | 2929 |
| morse code characters learned | debatable |

## what's in here

`$EDITOR` — neovim. post-burnout config. philosophy-driven, minimal, resists
tweaking. 7 plugins, <=20 mappings, 1 theme (kanagawa dragon). every line
earns its place or gets deleted.

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
