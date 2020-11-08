#!/usr/bin/env sh
set -e
if [ -d "$1" ]; then
    cd "$1" || exit 1
    fd --color=always --maxdepth=1
else
    case "$1" in
        *.tar.*|*.rar|*.7z|*.zip|*.iso|*.zst|*.exe|*.pk3|*.tar|*.tgz|*.cbz)
            extract -l "$1"
            ;;
        *.mkv)
            mkvmerge -J "$1" | jq --sort-keys --color-output
            ;;
        *)
            # set line count to avoid unnecessary page length.
            # 1024 is overkill, but using $(tput lines) is not reliable.
            bat -r :1024 --color=always --plain -- "$1"
    esac
fi
