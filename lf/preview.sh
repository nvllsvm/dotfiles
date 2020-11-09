#!/usr/bin/env sh
set -e
if [ -d "$1" ]; then
    cd "$1" || exit 1
    fd --color=always --maxdepth=1
else
    mimetype="$(xdg-mime query filetype "$1")"
    case "$mimetype" in
        application/java-archive|\
        application/x-rar|\
        application/x-tar|\
        application/zip|\
        application/zstd)
            extract -l -- "$1"
            ;;
        audio/*|\
        video/*)
            ffprobe -hide_banner -- "$1" 2>&1
            ;;
        image/*)
            output="$(identify -- "$1")"
            # strip filename
            echo "${output#*"$1" }"
            ;;
        *)
            # set line count to avoid unnecessary page length.
            # 1024 is overkill, but using $(tput lines) is not reliable.
            bat -r :1024 --color=always --plain -- "$1"
    esac
fi
