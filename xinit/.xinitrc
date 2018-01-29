if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

setxkbmap -option terminate:ctrl_alt_bksp
xset -dpms; xset s off

i3-config-build

compton &

export QT_QPA_PLATFORMTHEME="qt5ct"

$(which xinit-$HOSTNAME) &

export MESA_GLSL_CACHE_DISABLE=0
exec i3
