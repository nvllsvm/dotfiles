if command -v git-sync > /dev/null; then
    function gs() {
        git sync "$@"
        if [ $# -gt 0 ]; then
            cd "$(git sync --show-dir "$@")"
        fi
    }
fi
