if [ "$HOST" = 'termux' ]; then
    # exec is broken in termux
    return
fi

if [ -t 0 ] && [ -n "$SSH_TTY" ] && [ -z "$TMUX" ]; then
    exec tmux-attach
fi

if [ -f ~/.usesway ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    export QT_QPA_PLATFORM=wayland
    set -a
    eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)"
    set +a
    exec sway
fi

case "$HOST" in
    apollo|deimos|mars|phobos)
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && [ -z "$(pidof Xorg)" ]; then
            exec startx
        fi
        ;;
esac
