#!/usr/bin/env sh
case "$1" in
    *.tar.*|*.rar|*.7z|*.zip|*.iso|*.zst|*.exe|*.pk3)
        if extract -l "$1"; then
            exit
        fi
        ;;
esac
# set line count to avoid unnecessary page length.
# 1024 is overkill, but using $(tput lines) is not reliable.
exec bat -r :1024 --color=always --plain -- "$1"
