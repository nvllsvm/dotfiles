if command -v tmux > /dev/null; then
    path=("$DOTFILES_DIR"/scripts/tmux "$path[@]")
fi
