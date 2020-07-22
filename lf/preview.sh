#!/usr/bin/env sh
if [ -d "$1" ]; then
    cd "$1" || exit 1
    fd --color=always --maxdepth=1
    exit
else
    case "$1" in
        *.tar.*|*.rar|*.7z|*.zip|*.iso|*.zst|*.exe|*.pk3|*.tar|*.tgz)
            extract -l "$1"
            ;;
        *)
            # set line count to avoid unnecessary page length.
            # 1024 is overkill, but using $(tput lines) is not reliable.
            bat -r :1024 --color=always --plain -- "$1"
    esac
fi
