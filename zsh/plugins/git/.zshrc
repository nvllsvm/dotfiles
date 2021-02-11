if command -v git > /dev/null; then
    function gs() {
        if git sync "$1"; then
            echo "$1" >> ~/.cache/gs
            sort -u ~/.cache/gs | sponge ~/.cache/gs
            if [ $# -gt 0 ]; then
                cd "$(git sync --show-dir "$@")"
            fi
        fi
    }

    alias g='git s'
fi
