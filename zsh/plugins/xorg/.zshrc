if [ -f /tmp/.X0-lock ]; then
    export XAUTHORITY="${XAUTHORITY:-${HOME}/.Xauthority}"
    export DISPLAY="${DISPLAY:-:0}"
fi
