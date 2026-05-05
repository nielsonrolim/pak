# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A fish-shell wrapper around `paru` (Arch Linux AUR helper) that exposes a smaller, friendlier subcommand surface (`pak upgrade`, `pak install`, `pak remove`, etc.). Two files, no build step, no tests.

- `functions/pak.fish` — the `pak` function: a `switch` statement dispatching subcommands to `paru`, `pacman`, or `flatpak`.
- `completions/pak.fish` — fish completions: subcommand list plus per-subcommand argument completers backed by `pacman -Ssq` (repo packages) or `pacman -Qq` (installed packages).

## Install / try changes locally

Fish auto-loads from `~/.config/fish/functions/` and `~/.config/fish/completions/`. To test edits, either symlink this repo's dirs into those locations, or copy the changed file and run `source ~/.config/fish/functions/pak.fish` in an open shell.

## Editing rule: keep both files in sync

Subcommand aliases live in **two** places that must agree:

1. The `case` arms in `functions/pak.fish` (e.g. `case install add i`).
2. The `complete -c pak -n '__fish_use_subcommand' -f -a '...'` lines and the `__fish_seen_subcommand_from ...` guards in `completions/pak.fish`.

When adding/renaming a subcommand or alias, update both. The completion guard's alias list must match the `case` line exactly, or tab-completion will silently break for that alias.

## Runtime assumptions

- `paru` and `pacman` are on PATH (Arch / Arch-derived systems).
- `pak upgrade` also runs `flatpak upgrade`; on systems without flatpak it will error on the second half of the `&&` chain.
- `pak autoremove` defines orphans as `pacman -Qdtq` (unrequired deps) and pipes them to `paru -Rns`.
