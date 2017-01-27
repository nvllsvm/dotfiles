if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

setxkbmap -option terminate:ctrl_alt_bksp
#xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

xset -dpms; xset s off

export __GL_SYNC_TO_VBLANK=1
export __GL_SYNC_DISPLAY_DEVICE=DFP-6
export __VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=DFP-6

export SDL_VIDEO_FULLSCREEN_HEAD=0
export SDL_AUDIODRIVER=alsa

~/.bin/general/starttriple &
#~/.bin/general/startcompositing &

xrdb ~/.Xresources &
xbindkeys &
nextcloud &

exec dbus-launch i3
