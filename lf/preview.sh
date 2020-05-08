#!/usr/bin/env sh
case "$1" in
    *.tar.*|*.xz|*.zst|*.7z|*.zip|*.iso)
        exec extract -l "$1"
        ;;
    *)
        # set line count to avoid unnecessary page length.
        # 1024 is overkill, but using $(tput lines) is not reliable.
        exec bat -r :1024 --color=always --plain -- "$1"
esac
