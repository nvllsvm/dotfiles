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

setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option caps:escape

xset -dpms
xset s off

compton &
/usr/lib/gsd-xsettings &
xbindkeys &
xss-lock -- lock-screen &

if command -v xinit-$(hostname) > /dev/null; then
    xinit-$(hostname)
fi

if command -v mpd-notification > /dev/null; then
    pkill -9 -f mpd-notification
    mpd-notification &
fi

nm-applet &
syncthing-gtk &

setup-outputs

exec i3
