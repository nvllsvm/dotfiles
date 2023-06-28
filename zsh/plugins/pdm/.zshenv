if command -v pdm > /dev/null; then
    export PIPX_HOME=~/.local/pipx
    export PIPX_BIN_DIR="${PIPX_HOME}/bin"

    path=(
        "$PIPX_BIN_DIR"
        "$path[@]"
    )
fi
