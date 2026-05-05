function pak --description "paru command wrapper"
    if test (count $argv) -eq 0
        echo "Usage:"
        echo "  pak upgrade            # paru -Syu && flatpak upgrade"
        echo "  pak search <pkg>        # paru -Ss <pkg>"
        echo "  pak install <pkg>...    # paru -S <pkg>"
        echo "  pak remove <pkg>...     # paru -Rns <pkg>"
        echo "  pak info <pkg>          # paru -Si <pkg>"
        echo "  pak aur                # list AUR/foreign packages (pacman -Qm)"
        echo "  pak clean               # paru -Sc"
        echo "  pak autoremove          # remove orphaned packages"
        return 1
    end

    set subcmd $argv[1]
    set args $argv[2..-1]

    switch $subcmd
        case upgrade up
            paru -Syu && flatpak upgrade

        case search s
            test (count $args) -gt 0; or begin
                echo "pak search <package>"
                return 1
            end
            paru -Ss $args

        case install add i
            test (count $args) -gt 0; or begin
                echo "pak install <package>..."
                return 1
            end
            paru -S $args

        case remove rm uninstall
            test (count $args) -gt 0; or begin
                echo "pak remove <package>..."
                return 1
            end
            paru -Rns $args

        case info
            test (count $args) -gt 0; or begin
                echo "pak info <package>"
                return 1
            end
            paru -Si $args

        case aur aur-list
            # Foreign packages (not in official repos) — usually AUR
            pacman -Qm

        case clean
            paru -Sc

        case autoremove orphans
            set orphans (pacman -Qdtq)
            if test (count $orphans) -eq 0
                echo "No orphaned packages found."
            else
                paru -Rns $orphans
            end

        case '*'
            echo "Unknown command: $subcmd"
            echo "Run: pak (no args) for help"
            return 1
    end
end
