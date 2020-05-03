#!/usr/bin/env sh
case "$1" in
    *.tar.xz|*tar.gz|*.xz|*.zst|*.7z|*.zip)
        exec extract -l "$1"
        ;;
    *)
        exec highlight --out-format=ansi -- "$1"
esac
