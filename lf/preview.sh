#!/usr/bin/env sh
case "$1" in
    *.tar.zst)
        exec tar -tvf "$1"
        ;;
    *.tar.xz|*tar.gz|*.xz|*.zst|*.7z|*.zip|*.iso)
        exec extract -l "$1"
        ;;
    *)
        exec highlight --out-format=ansi -- "$1"
esac
