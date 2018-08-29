if command -v docker > /dev/null; then
    path=("$DOTFILES_DIR"/scripts/docker "$path[@]")
    full-update add 'git install gitlab:nvllsvm/shtty && ln -s ~/.local/git/shtty/bin ~/.bin/shtty'
fi
