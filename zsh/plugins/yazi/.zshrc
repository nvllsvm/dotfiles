__yazi="$(command -v yazi)"
if [ -z "$__yazi" ]; then
    unset __yazi
else
    yazi() {
        local cwdfile
        local ret
        cwdfile=/tmp/"yazicwd"
        "$__yazi" --cwd-file="${cwdfile}" "$@"
        ret=$?
        if [ $ret = 0 ]; then
            cd "$(cat "$cwdfile")"
        fi
        rm -f "$cwdfile"
        return $ret
    }
    alias fm=yazi
fi
