# ~/.config/fish/completions/pak.fish
# Completions for pak (paru wrapper) — robust (no `test` parsing issues)

function __pak_repo_pkgs
    pacman -Ssq 2>/dev/null
end

function __pak_installed_pkgs
    pacman -Qq 2>/dev/null
end

# ---- subcommands (only when fish expects a subcommand) ----
complete -c pak -n '__fish_use_subcommand' -f -a 'upgrade up'          -d 'Upgrade system (paru -Syu && flatpak upgrade)'
complete -c pak -n '__fish_use_subcommand' -f -a 'search s'           -d 'Search packages (paru -Ss)'
complete -c pak -n '__fish_use_subcommand' -f -a 'install add i'      -d 'Install packages (paru -S)'
complete -c pak -n '__fish_use_subcommand' -f -a 'remove rm uninstall' -d 'Remove packages (paru -Rns)'
complete -c pak -n '__fish_use_subcommand' -f -a 'info'               -d 'Package info (paru -Si)'
complete -c pak -n '__fish_use_subcommand' -f -a 'clean'              -d 'Clean cache (paru -Sc)'

# ---- args after subcommand ----
complete -c pak -n '__fish_seen_subcommand_from search s' \
    -f -a '(__pak_repo_pkgs)'

complete -c pak -n '__fish_seen_subcommand_from install add i' \
    -f -a '(__pak_repo_pkgs)'

complete -c pak -n '__fish_seen_subcommand_from info' \
    -f -a '(__pak_repo_pkgs)'

complete -c pak -n '__fish_seen_subcommand_from remove rm uninstall' \
    -f -a '(__pak_installed_pkgs)'

complete -c pak -n '__fish_use_subcommand' -f -a 'aur aur-list' -d 'List AUR/foreign packages (pacman -Qm)'

complete -c pak -n '__fish_use_subcommand' -f -a 'autoremove orphans' -d 'Remove orphaned packages (pacman -Qdtq | paru -Rns)'
