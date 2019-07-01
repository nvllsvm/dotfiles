if command -v tmux > /dev/null; then
    path=("$DOTFILES"/scripts/tmux "$path[@]")
fi
