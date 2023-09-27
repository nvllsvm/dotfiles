if [ -t 0 ] && [ -n "$SSH_TTY" ] && [ -z "$TMUX" ] && command -v tmux-attach &> /dev/null; then
    if [ "$HOST" = 'termux' ]; then
        # exec is broken in termux
        tmux-attach
        exit
    else
        exec tmux-attach
    fi
fi

if [ -f ~/.usesway ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    export QT_QPA_PLATFORM=wayland
    set -a
    eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)"
    set +a
    exec sway
fi

case "$HOST" in
    mars|phobos)
        if [ -z "$(pidof Xorg)" ]; then
            exec systemd-cat startx
        fi
        ;;
esac
