# brew

Homebrew configuration for this machine. All package management goes through here.

## Files

| File                | Purpose                                                   |
| ------------------- | --------------------------------------------------------- |
| `Brewfile`          | Declarative list of all formulae, casks, and taps         |
| `brew.env`          | Homebrew env vars — source from `.zprofile`               |
| `non-brew-apps.md`  | Apps requiring App Store or direct download               |

## Setup

Add to `.zprofile`:

```sh
source "$HOME/.config/brew/brew.env"
```

This sets `HOMEBREW_BUNDLE_FILE` so that all `brew bundle` commands resolve to
this directory automatically, without needing `--file` flags.

## brew bundle commands

| Command                        | What it does                                            |
| ------------------------------ | ------------------------------------------------------- |
| `brew bundle`                  | Install and upgrade everything in the Brewfile          |
| `brew bundle check`            | Show what's in the Brewfile but not yet installed       |
| `brew bundle check --verbose`  | Same, with full detail                                  |
| `brew bundle cleanup`          | Preview packages installed but absent from the Brewfile |
| `brew bundle cleanup --force`  | Remove those packages (destructive — preview first)     |
| `brew bundle dump`             | Export the current installed state into a new Brewfile  |

## Updating packages

```sh
brew upgrade               # update formulae only
brew upgrade --greedy      # update formulae + auto-updating casks
```

Many casks (Slack, Discord, Chrome, Zoom) have built-in auto-updaters and
self-update outside of Homebrew. `--greedy` updates the Homebrew record to
match, keeping drift between `brew info` and the actual installed version to
a minimum.

## Adopting existing apps

You don't need to uninstall and reinstall an app to put it under Homebrew
management. Running `brew install --cask <name>` on an already-installed app
either links it into Homebrew's manifest, or installs alongside if Homebrew
can't detect the existing installation.

The real value is migration: once an app is in the Brewfile, a new machine
picks it up automatically via `brew bundle`. On the existing machine, the main
win is `brew upgrade --greedy` keeping it current.

## Adding a new package

1. Install: `brew install <formula>` or `brew install --cask <cask>`
2. Add the entry to `Brewfile` with an inline comment (one line, what it does)
3. Commit

## Removing a package

1. For apps: drag to **AppCleaner** or **PearCleaner** before uninstalling —
   this removes all associated preference files, caches, and launch agents
   that a plain `brew uninstall` would leave behind
2. Remove the entry from `Brewfile`
3. Uninstall: `brew uninstall <formula>` or `brew uninstall --cask <cask>`
4. Optionally run `brew bundle cleanup` to find any other orphans

## Checking for drift

Run periodically to verify the installed state matches the Brewfile:

```sh
brew bundle check --verbose
```

If something is installed locally but not in the Brewfile, either add it or
remove it — the Brewfile is the source of truth.

## Non-brew apps

Apps that can't be managed by Homebrew (App Store purchases, unsigned
downloads) are listed in `non-brew-apps.md` with direct links to their
AU App Store pages or download URLs.
