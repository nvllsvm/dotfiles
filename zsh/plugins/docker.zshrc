if command -v docker > /dev/null; then
    path=("$DOTFILES_DIR"/scripts/docker "$path[@]")
    full-update add 'shtty-update'
    full-update add 'srvit --pull'
fi
