if command -v docker > /dev/null; then
    path=("$DOTFILES"/scripts/docker "$path[@]")
    full-update add 'shtty-update'
fi
