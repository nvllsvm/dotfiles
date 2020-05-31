if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

export XDG_CURRENT_DESKTOP=i3

set -a
eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)"
set +a

xset s off -dpms

/usr/lib/gsd-xsettings &

picom &
xss-lock -- lock-screen &

snixembed --fork
if command -v xinit-$(hostname) > /dev/null; then
    xinit-$(hostname)
fi

nm-applet &

if command -v mpd-notifier > /dev/null; then
    mpd-notifier --library ~/.config/mpd/library &
fi

autorandr --change --force

exec i3
