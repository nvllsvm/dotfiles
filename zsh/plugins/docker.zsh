if command -v docker > /dev/null; then
    export DOCKER_CLI_EXPERIMENTAL=enabled
    path=("$DOTFILES"/scripts/docker "$path[@]")
fi
