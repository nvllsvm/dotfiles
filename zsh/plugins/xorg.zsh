if command -v Xorg > /dev/null; then
    path=("$DOTFILES"/scripts/xorg "$path[@]")
fi
