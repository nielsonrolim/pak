# ~/.config/fish/completions/pak.fish
# Completions for pak (paru wrapper) — robust (no `test` parsing issues)

function __pak_repo_pkgs
    pacman -Ssq 2>/dev/null
end

function __pak_installed_pkgs
    pacman -Qq 2>/dev/null
end

# ---- subcommands (only when fish expects a subcommand) ----
complete -c pak -n '__fish_use_subcommand' -f -a 'upgrade up'           -d 'Upgrade system (paru -Syu and flatpak upgrade if available)'
complete -c pak -n '__fish_use_subcommand' -f -a 'update refresh'       -d 'Refresh package DB (paru -Sy)'
complete -c pak -n '__fish_use_subcommand' -f -a 'search s'             -d 'Search packages (paru -Ss)'
complete -c pak -n '__fish_use_subcommand' -f -a 'install add i'        -d 'Install packages (paru -S)'
complete -c pak -n '__fish_use_subcommand' -f -a 'remove rm uninstall'  -d 'Remove packages (paru -Rns)'
complete -c pak -n '__fish_use_subcommand' -f -a 'info'                 -d 'Package info (paru -Si)'
complete -c pak -n '__fish_use_subcommand' -f -a 'owns'                 -d 'Find package owning a file (pacman -Qo)'
complete -c pak -n '__fish_use_subcommand' -f -a 'files'                -d 'List files in a package (pacman -Ql)'
complete -c pak -n '__fish_use_subcommand' -f -a 'list explicit'        -d 'List explicitly installed packages (pacman -Qe)'
complete -c pak -n '__fish_use_subcommand' -f -a 'aur aur-list'         -d 'List AUR/foreign packages (pacman -Qm)'
complete -c pak -n '__fish_use_subcommand' -f -a 'clean'                -d 'Clean cache (paru -Sc)'
complete -c pak -n '__fish_use_subcommand' -f -a 'autoremove orphans'   -d 'Remove orphaned packages (pacman -Qdtq | paru -Rns)'

# ---- args after subcommand ----
complete -c pak -n '__fish_seen_subcommand_from search s' \
    -f -a '(__pak_repo_pkgs)'

complete -c pak -n '__fish_seen_subcommand_from install add i' \
    -f -a '(__pak_repo_pkgs)'

# `info` works on repo + AUR; we approximate AUR coverage with installed packages.
complete -c pak -n '__fish_seen_subcommand_from info' \
    -f -a '(__pak_repo_pkgs) (__pak_installed_pkgs)'

complete -c pak -n '__fish_seen_subcommand_from remove rm uninstall' \
    -f -a '(__pak_installed_pkgs)'

complete -c pak -n '__fish_seen_subcommand_from files' \
    -f -a '(__pak_installed_pkgs)'

# `owns` takes a filesystem path — fall through to fish's default file completion.

# Subcommands that take no further arguments — block stray file completion.
complete -c pak -n '__fish_seen_subcommand_from upgrade up update refresh aur aur-list clean autoremove orphans list explicit' -f
