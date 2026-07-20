function pak --description "paru command wrapper"
    if test (count $argv) -eq 0
        echo "Usage:"
        echo "  pak upgrade             # paru -Syu (and flatpak upgrade if available)"
        echo "  pak maintain [args]     # full Cachy-Update maintenance run (cachy-update)"
        echo "  pak check               # list pending updates without applying them"
        echo "  pak update              # paru -Sy (refresh package DB only)"
        echo "  pak search <pkg>        # paru -Ss <pkg>"
        echo "  pak install <pkg>...    # paru -S <pkg>"
        echo "  pak remove <pkg>...     # paru -Rns <pkg>"
        echo "  pak info <pkg>          # paru -Si <pkg>"
        echo "  pak owns <file>         # pacman -Qo <file>"
        echo "  pak files <pkg>         # pacman -Ql <pkg>"
        echo "  pak list                # explicitly installed packages (pacman -Qe)"
        echo "  pak aur                 # AUR/foreign packages (pacman -Qm)"
        echo "  pak aur-audit           # check installed AUR packages against the compromised list"
        echo "  pak clean               # paru -Sc"
        echo "  pak autoremove          # remove orphaned packages"
        return 1
    end

    set subcmd $argv[1]
    set args $argv[2..-1]

    switch $subcmd
        case upgrade up
            paru -Syu
            if command -q flatpak
                flatpak upgrade
            end

        case maintain cu full full-upgrade
            # Full CachyOS maintenance flow: repo + AUR updates plus news,
            # orphans, cache cleanup, pacnew handling, kernel/reboot &
            # service-restart checks. Any extra args are passed through
            # (e.g. `pak maintain --devel`, `pak maintain --news 10`).
            if command -q cachy-update
                cachy-update $args
            else if command -q arch-update
                arch-update $args
            else
                echo "Cachy-Update is not installed. Install it with:"
                echo "  pak install cachy-update"
                return 1
            end

        case check co
            if command -q cachy-update
                cachy-update --list
            else if command -q arch-update
                arch-update --list
            else
                paru -Qu
            end

        case update refresh
            paru -Sy

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

        case owns
            test (count $args) -gt 0; or begin
                echo "pak owns <file>..."
                return 1
            end
            pacman -Qo $args

        case files
            test (count $args) -gt 0; or begin
                echo "pak files <package>..."
                return 1
            end
            pacman -Ql $args

        case list explicit
            pacman -Qe

        case aur aur-list
            pacman -Qm

        case aur-audit aur-sec aur-security
            # Check installed AUR (foreign) packages against the published
            # "Arch Linux AUR Compromised" list. Requires curl to fetch it.
            if not command -q curl
                echo "curl is required to fetch the compromised package list. Install it with:"
                echo "  pak install curl"
                return 1
            end
            set -l url "https://md.archlinux.org/s/SxbqukK6IA/download"
            set -l compromised (curl -fsSL --max-time 20 $url 2>/dev/null | string match -rv '^```')
            if test (count $compromised) -eq 0
                echo "Could not fetch the compromised package list from:"
                echo "  $url"
                echo "Check your network connection and try again."
                return 1
            end
            set -l installed (pacman -Qmq 2>/dev/null)
            if test (count $installed) -eq 0
                echo "No AUR (foreign) packages installed — nothing to check."
                return 0
            end
            set -l hits
            for pkg in $installed
                if contains -- $pkg $compromised
                    set -a hits $pkg
                end
            end
            echo "Checked "(count $installed)" installed AUR package(s) against "(count $compromised)" known-compromised entries."
            if test (count $hits) -eq 0
                echo "No installed AUR packages are on the compromised list."
            else
                echo "WARNING: the following installed AUR packages are on the compromised list:"
                for pkg in $hits
                    echo "  $pkg"
                end
                echo "Review these packages and consider removing them with: pak remove <package>"
                return 1
            end

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
