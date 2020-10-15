if [ -t 0 ] && [ -n "$SSH_TTY" ] && [ -z "$TMUX" ]; then
    exec tmux-attach
fi

case "$HOST" in
    apollo|mars|phobos|deimos)
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && [ -z "$(pidof Xorg)" ]; then
            exec startx
        fi
        ;;
esac
