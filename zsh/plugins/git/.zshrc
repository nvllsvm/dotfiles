if command -v git > /dev/null; then
    gs() {
        if git sync "$1"; then
            echo "$1" | sort -u - ~/.cache/gs | tr '[:upper:]' '[:lower:]' | sponge ~/.cache/gs
            if [ $# -gt 0 ]; then
                cd "$(git sync --show-dir "$@")"
            fi
        fi
    }

    alias g='git s'
fi
