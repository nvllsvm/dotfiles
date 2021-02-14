if command -v git > /dev/null; then
    gs() {
        touch ~/.cache/gs
        case $# in
            0)
                target="$(fzf < ~/.cache/gs)"
                ;;
            1)
                target="$1"
                ;;
            *)
                echo 'error: unexpected arguments' >&2
                return 1
        esac

        if ! [ -t 1 ]; then
            git sync --show-dir "$target"
            return
        fi

        if git sync "$target"; then
            print -s "gs $target"
            echo "$target" | sort -u - ~/.cache/gs | tr '[:upper:]' '[:lower:]' | sponge ~/.cache/gs
            cd "$(git sync --show-dir "$target")"
        fi
    }
fi
