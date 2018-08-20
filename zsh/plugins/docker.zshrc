if command -v docker > /dev/null; then
    path=("$DOTFILES_DIR"/scripts/docker "$path[@]")
fi
