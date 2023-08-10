if [ -f /tmp/.X0-lock ]; then
    export XAUTHORITY=~/.Xauthority
    export DISPLAY=':0'
fi
