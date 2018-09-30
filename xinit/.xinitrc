if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

setxkbmap -option terminate:ctrl_alt_bksp
xset -dpms; xset s off
setup-outputs

i3-config-build

compton &
/usr/lib/gsd-xsettings &
xbindkeys &
xss-lock -- lock-screen &

xinit-$(hostname) &

pkill -9 -f mpd-notification
mpd-notification &
nm-applet &
blueberry-tray &
syncthing-gtk &

exec i3
