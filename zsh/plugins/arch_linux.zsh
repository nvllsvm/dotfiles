if command -v pacman > /dev/null; then
    alias ssh='TERM=xterm-256color ssh'
    full-update add 'arch-linux-update'
fi
