setxkbmap -option terminate:ctrl_alt_bksp 
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' 

xset -dpms; xset s off

export __GL_SYNC_TO_VBLANK=1
export __GL_SYNC_DISPLAY_DEVICE=DFP-0
export __VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=DFP-0

export GTK2_RC_FILES="$HOME/.gtkrc-2.0" 
export SDL_VIDEO_FULLSCREEN_HEAD=0 
export SDL_AUDIODRIVER=alsa

starttriple &

nvidia-settings --config=~/.nvidia-settings-rc -l &
nvidia-settings -a InitialPixmapPlacement=2 &

#chromium &

startcompositing &
exec dbus-launch awesome
