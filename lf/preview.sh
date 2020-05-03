#!/usr/bin/env sh
case "$1" in
    *.tar.xz|*tar.gz|*.xz|*.zst|*.7z|*.zip)
        exec extract -l "$1"
        ;;
    *)
        # 1024 is overkill, but using $(tput lines) doesn't seem to work consistently.
        # results are cutoff.
        exec highlight --out-format=ansi -- "$1"
esac
