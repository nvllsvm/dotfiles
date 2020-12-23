#!/usr/bin/env sh
set -e
default_preview() {
    # set line count to avoid unnecessary page length.
    # 1024 is overkill, but using $(tput lines) is not reliable.
    bat -r :1024 --color=always --plain -- "$1"
}

if [ -d "$1" ]; then
    cd "$1" || exit 1
    fd --color=always --maxdepth=1
else
    if command -v xdg-mime > /dev/null; then
        mimetype="$(xdg-mime query filetype "$1")"
    else
        mimetype="$(file --brief --mime-type "$1")"
    fi
    case "$mimetype" in
        application/epub+zip|\
        application/gzip|\
        application/java-archive|\
        application/vnd.rar|\
        application/x-7z-compressed|\
        application/x-cd-image|\
        application/x-compressed-tar|\
        application/x-dosexec|\
        application/x-iso9660-image|\
        application/x-ms-dos-executable|\
        application/x-rar|\
        application/x-tar|\
        application/x-zstd-compressed-tar|\
        application/zip|\
        application/zstd)
            extract -l -- "$1"
            ;;
        audio/x-mod)
            # xdg-mime reports go.mod files as this
            default_preview "$1"
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
            default_preview "$1"
    esac
fi
