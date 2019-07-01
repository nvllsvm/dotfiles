if command -v pacman > /dev/null; then
    alias ssh='TERM=xterm-256color ssh'
    path=("$DOTFILES/scripts/arch_linux" "$path[@]")

    full-update add 'arch-linux-update'

    if command -v mpd > /dev/null; then
        full-update add 'mpd-notification-update'
    fi
fi
