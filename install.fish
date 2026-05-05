#!/usr/bin/env fish

set -l script_dir (status dirname)
set -l src_fn   "$script_dir/functions/pak.fish"
set -l src_cmp  "$script_dir/completions/pak.fish"
set -l dst_fn   "$HOME/.config/fish/functions/pak.fish"
set -l dst_cmp  "$HOME/.config/fish/completions/pak.fish"

for f in $src_fn $src_cmp
    if not test -f $f
        echo "missing: $f"
        exit 1
    end
end

mkdir -p (dirname $dst_fn) (dirname $dst_cmp)

function __pak_install_one --argument-names src dst
    if test -f $dst; and cmp -s $src $dst
        echo "  unchanged: $dst"
        return 0
    end
    if test -f $dst
        cp $dst "$dst.bak"
        echo "  backed up: $dst -> $dst.bak"
    end
    cp $src $dst
    echo "  installed: $dst"
end

echo "installing pak:"
__pak_install_one $src_fn  $dst_fn
__pak_install_one $src_cmp $dst_cmp
echo "open a new fish shell (or run: source $dst_fn) to use pak."
