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
            echo "$1" | sort -u - ~/.cache/gs | tr '[:upper:]' '[:lower:]' | sponge ~/.cache/gs
            if [ $# -gt 0 ]; then
                cd "$(git sync --show-dir "$@")"
            fi
        fi
    }

    alias g='git s'
fi
