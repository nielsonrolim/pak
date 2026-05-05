#!/usr/bin/env fish

set -l targets \
    "$HOME/.config/fish/functions/pak.fish" \
    "$HOME/.config/fish/completions/pak.fish"

set -l removed 0
for f in $targets
    if test -L $f
        rm $f
        echo "  removed symlink: $f"
        set removed (math $removed + 1)
    else if test -f $f
        rm $f
        echo "  removed: $f"
        set removed (math $removed + 1)
    end
end

if test $removed -eq 0
    echo "nothing to remove."
else
    echo "uninstalled pak. open a new fish shell to drop the cached function."
end
