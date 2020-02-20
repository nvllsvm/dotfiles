notes() {
    local bin="$(whence -p notes)"
    if [ $# -eq 0 ]; then
        cd "$("$bin" -d)"
    else
        "$bin" "$@"
    fi
}
