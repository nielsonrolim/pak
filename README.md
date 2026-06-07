# pak

A small [fish shell](https://fishshell.com/) wrapper around [`paru`](https://github.com/Morganamilo/paru) that exposes a simpler, easier-to-remember subcommand surface for everyday Arch Linux package management.

```fish
pak upgrade             # paru -Syu (and flatpak upgrade if available)
pak maintain [args]     # full Cachy-Update maintenance run (cachy-update)
pak check               # list pending updates without applying them
pak update              # paru -Sy (refresh package DB only)
pak search <pkg>        # paru -Ss <pkg>
pak install <pkg>...    # paru -S <pkg>
pak remove <pkg>...     # paru -Rns <pkg>
pak info <pkg>          # paru -Si <pkg>
pak owns <file>         # pacman -Qo <file>
pak files <pkg>         # pacman -Ql <pkg>
pak list                # explicitly installed packages (pacman -Qe)
pak aur                 # AUR/foreign packages (pacman -Qm)
pak clean               # paru -Sc
pak autoremove          # remove orphaned packages (pacman -Qdtq | paru -Rns)
```

Tab completion is wired up for every subcommand: repo packages for `install` / `search`, repo + installed for `info`, installed packages for `remove` / `files`, and filesystem paths for `owns`.

## Requirements

- [fish](https://fishshell.com/) shell
- [`paru`](https://github.com/Morganamilo/paru) (AUR helper)
- `pacman` (Arch / Arch-derived distro)
- `flatpak` — optional; `pak upgrade` runs `flatpak upgrade` only if `flatpak` is on your PATH

## Install

```fish
git clone git@github.com:nielsonrolim/pak.git
cd pak
./install.fish
```

This copies `functions/pak.fish` and `completions/pak.fish` into `~/.config/fish/`, creating the directories if needed. The script is idempotent: re-running it skips files that haven't changed and backs up local edits to `*.bak` before overwriting.

Remove with `./uninstall.fish`.

If you'd rather track the repo and pick up changes with a `git pull`, symlink instead:

```fish
ln -s (pwd)/functions/pak.fish    ~/.config/fish/functions/pak.fish
ln -s (pwd)/completions/pak.fish  ~/.config/fish/completions/pak.fish
```

Either way, open a new fish shell (or `source ~/.config/fish/functions/pak.fish`) and `pak` is ready.

## Usage

Run `pak` with no arguments to print a help summary.

### Upgrade everything

```fish
pak upgrade
```

Runs `paru -Syu` and, if `flatpak` is on your PATH, follows up with `flatpak upgrade`. On systems without flatpak the second step is silently skipped.

### Run a full maintenance pass

```fish
pak maintain
```

Delegates to [`cachy-update`](https://github.com/CachyOS/cachy-update) (falling back to `arch-update`) for a complete maintenance flow: repo + AUR updates plus news, orphan removal, cache cleanup, pacnew handling, and kernel/reboot and service-restart checks. Any extra arguments are passed straight through, e.g. `pak maintain --devel` or `pak maintain --news 10`. If neither tool is installed, it prints how to install `cachy-update` and exits.

### Check for pending updates

```fish
pak check
```

Lists available updates without applying them. Uses `cachy-update --list` (or `arch-update --list`) when available, otherwise falls back to `paru -Qu`.

### Refresh the package database

```fish
pak update
```

Runs `paru -Sy` — useful before searching to make sure suggestions reflect the latest repo state. Doesn't upgrade anything.

### Search the repos and AUR

```fish
pak search firefox
```

### Install one or more packages

```fish
pak install neovim ripgrep fd
```

Tab completion suggests package names from the official repos.

### Show package info

```fish
pak info neovim
```

Tab completion offers both repo and installed packages, so AUR packages you've already installed show up.

### Remove packages (with their unused deps and config)

```fish
pak remove neovim
```

Uses `paru -Rns`, so unused dependencies and saved configs are removed alongside the package. Tab completion here is restricted to *installed* packages.

### Find which package owns a file

```fish
pak owns /usr/bin/fish
```

Equivalent to `pacman -Qo`. Tab-completes filesystem paths.

### List the files installed by a package

```fish
pak files fish
```

Equivalent to `pacman -Ql`. Tab completion is restricted to installed packages.

### List explicitly installed packages

```fish
pak list
```

Equivalent to `pacman -Qe` — packages you asked for, as opposed to dependencies pulled in transitively. Useful for auditing your install or capturing it for replication.

### List installed AUR / foreign packages

```fish
pak aur
```

Equivalent to `pacman -Qm` — handy for auditing what came from outside the official repos.

### Clean the package cache

```fish
pak clean
```

### Remove orphaned packages

```fish
pak autoremove
```

Finds unrequired dependencies via `pacman -Qdtq` and removes them with `paru -Rns`. Prints a friendly message and exits cleanly when there's nothing to remove.

## Subcommand aliases

Most subcommands have shorter aliases:

| Subcommand   | Aliases              |
| ------------ | -------------------- |
| `upgrade`    | `up`                 |
| `maintain`   | `cu`, `full`         |
| `check`      | `co`                 |
| `update`     | `refresh`            |
| `search`     | `s`                  |
| `install`    | `add`, `i`           |
| `remove`     | `rm`, `uninstall`    |
| `list`       | `explicit`           |
| `aur`        | `aur-list`           |
| `autoremove` | `orphans`            |

## License

[Apache License 2.0](LICENSE)
