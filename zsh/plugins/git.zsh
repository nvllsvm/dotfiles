if command -v git > /dev/null; then
    function gs() {
        git sync "$@"
        if [ $# -gt 0 ]; then
            cd "$(git sync --show-dir "$@")"
        fi
    }

    alias g='git s'
fi
