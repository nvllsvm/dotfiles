if command -v git > /dev/null; then
    gs() {
        case "$1" in
            -*)
                git-sync "$@"
                return $?
                ;;
        esac
        case $# in
            0)
                target="$(git-sync --show-cache | fzf --tac --exact --no-sort)"
                if [ -z "$target" ]; then
                    return 130
                fi
                ;;
            1)
                target="$1"
                ;;
            *)
                echo 'error: unexpected arguments' >&2
                return 1
        esac

        if ! [ -t 1 ]; then
            git-sync --show-dir "$target"
            return
        fi

        local repo_dir
        repo_dir="$(git-sync "$target")"
        if [ -z "$repo_dir" ]; then
            return 130
        else
            cd "$repo_dir"
        fi
    }
fi
