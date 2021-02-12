if command -v git > /dev/null; then
    gs() {
        case $# in
            0)
                target="$(fzf < ~/.cache/gs)"
                ;;
            1)
                target = "$1"
                ;;
            *)
                echo 'error: unexpected arguments' >&2
                return 1
        esac

        if git sync "$target"; then
            echo "$target" | sort -u - ~/.cache/gs | tr '[:upper:]' '[:lower:]' | sponge ~/.cache/gs
            cd "$(git sync --show-dir "$@")"
        fi
    }

    alias g='git s'
fi
