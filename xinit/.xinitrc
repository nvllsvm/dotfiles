if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

setxkbmap -option terminate:ctrl_alt_bksp
xset -dpms; xset s off

$(which xinit-$HOSTNAME 2> /dev/null)

i3-build-config

compton &

export QT_QPA_PLATFORMTHEME="qt5ct"

exec i3
