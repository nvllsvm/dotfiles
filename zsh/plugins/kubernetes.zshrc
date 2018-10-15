if command -v kubectl > /dev/null; then
    path=("$DOTFILES"/scripts/kubernetes "$path[@]")
fi
