# pak

A small [fish shell](https://fishshell.com/) wrapper around [`paru`](https://github.com/Morganamilo/paru) that exposes a simpler, easier-to-remember subcommand surface for everyday Arch Linux package management.

```fish
pak upgrade            # paru -Syu && flatpak upgrade
pak search <pkg>       # paru -Ss <pkg>
pak install <pkg>...   # paru -S <pkg>
pak remove <pkg>...    # paru -Rns <pkg>
pak info <pkg>         # paru -Si <pkg>
pak aur                # list AUR/foreign packages (pacman -Qm)
pak clean              # paru -Sc
pak autoremove         # remove orphaned packages (pacman -Qdtq | paru -Rns)
```

Tab completion is wired up for every subcommand, with package name suggestions sourced from `pacman` (repo packages for `install` / `search` / `info`, installed packages for `remove`).

## Requirements

- [fish](https://fishshell.com/) shell
- [`paru`](https://github.com/Morganamilo/paru) (AUR helper)
- `pacman` (Arch / Arch-derived distro)
- `flatpak` — only required if you use `pak upgrade`

## Install

```fish
git clone git@github.com:nielsonrolim/pak.git
cd pak
./install.fish
```

This copies `functions/pak.fish` and `completions/pak.fish` into `~/.config/fish/`, creating the directories if needed.

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

Runs `paru -Syu` (refresh + upgrade repo and AUR packages) and then `flatpak upgrade`. Skip the second half by upgrading directly with `paru -Syu` if you don't use flatpak.

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

### Remove packages (with their unused deps and config)

```fish
pak remove neovim
```

Uses `paru -Rns`, so unused dependencies and saved configs are removed alongside the package. Tab completion here is restricted to *installed* packages.

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
| `search`     | `s`                  |
| `install`    | `add`, `i`           |
| `remove`     | `rm`, `uninstall`    |
| `aur`        | `aur-list`           |
| `autoremove` | `orphans`            |

## License

[Apache License 2.0](LICENSE)
