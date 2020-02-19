#!/usr/bin/env sh
case "$1" in
    *.tar.xz|*tar.gz)
        exec tar -tvf "$1"
        ;;
    *.xz)
        exec xz -l -- "$1"
        ;;
    *.zst)
        exec zstd -l -- "$1"
        ;;
    *.7z|*.zip)
        exec 7z l -- "$1"
        ;;
    *)
        # 1024 is overkill, but using $(tput lines) doesn't seem to work consistently.
        # results are cutoff.
        exec bat -r :1024 --color=always --plain -- "$1"
esac
