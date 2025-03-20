__lf="$(command -v lf)"
if [ -z "$__lf" ]; then
    unset __lf
else
    lf() {
        local should_cd=1
        local arg
        for arg in "$@"; do
            case "$arg" in
                '--')
                    break
                    ;;
                '-'*)
                    should_cd=0
                    break
                    ;;
            esac
        done
        if [ "$should_cd" = 1 ]; then
            cd "$("$__lf" -print-last-dir "$@")"
        else
            "$__lf" "$@"
        fi
    }
fi
