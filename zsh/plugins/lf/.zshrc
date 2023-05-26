__lf="$(command -v lf)"
if [ -z "$__lf" ]; then
    unset __lf
else
    lf() {
        local tmp="$(mktemp)"
        # redirect stderr https://github.com/gokcehan/lf/issues/1167
        "$__lf" -last-dir-path="$tmp" "$@" 2>> ~/.local/share/lf/error.log
        if [ -f "$tmp" ]; then
            local dir="$(cat "$tmp")"
            rm -f "$tmp"
            if [ -d "$dir" ]; then
                if [ "$dir" != "$(pwd)" ]; then
                    cd "$dir"
                fi
            fi
        fi
    }
fi
