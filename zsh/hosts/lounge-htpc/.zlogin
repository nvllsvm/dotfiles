if [ -f ~/.usesway ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    export QT_QPA_PLATFORM=wayland
    set -a
    eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)"
    set +a
    case "$HOST" in
        lounge-htpc)
            exec systemd-cat -t sway sway --config ~/.config/sway/config.lounge-htpc
            ;;
        *)
            exec systemd-cat -t sway sway
            ;;
    esac
fi

case "$HOST" in
    mars|phobos)
        if [ -z "$(pidof Xorg)" ] && [ -z "$(pidof sway)" ]; then
            exec systemd-cat -t startx startx
        fi
        ;;
esac
