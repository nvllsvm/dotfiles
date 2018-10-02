if command -v pacman > /dev/null; then
    alias ssh='TERM=xterm-256color ssh'
    path=("$DOTFILES_DIR/scripts/arch_linux" "$path[@]")

    full-update add 'arch-linux-update'
    full-update add 'etc-backup-desktop'
fi
