__lf="$(command -v lf)"
if [ -z "$__lf" ]; then
    unset __lf
else
    lf() {
        cd "$("$__lf" -print-last-dir "$@")"
    }
fi
