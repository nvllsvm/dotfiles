if [ "$XDG_VTNR" -eq 1 ] && [ -z "$WAYLAND_DISPLAY" ]; then
    eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)"
    exec systemd-cat -t sway sway
fi
