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
