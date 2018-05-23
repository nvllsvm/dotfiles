if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GTK_THEME=Adwaita
export MOZ_USE_XINPUT2=1

setxkbmap -option terminate:ctrl_alt_bksp
xset -dpms; xset s off
i3-config-build

compton &
/usr/lib/gsd-xsettings &
xbindkeys &
xss-lock -- lock-screen &

apply-display-calibration

xinit-$HOSTNAME &

mpd-notification &
nm-applet &
syncthing-gtk &

exec i3
