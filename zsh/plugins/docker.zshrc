if command -v docker > /dev/null; then
    path=("$DOTFILES_DIR"/scripts/docker "$path[@]")
fi

full-update add 'git install gitlab:nvllsvm/shtty'
