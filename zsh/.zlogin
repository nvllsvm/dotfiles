if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 && -z "$(pidof Xorg)" ]]; then
    exec startx
fi
