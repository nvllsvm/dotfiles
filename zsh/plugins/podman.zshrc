if command -v podman > /dev/null; then
    path=("$DOTFILES"/scripts/podman "$path[@]")
fi
