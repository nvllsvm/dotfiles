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

echo $DBUS_SESSION_BUS_ADDRESS
# ensure consistent value in tmux for X restarts
export I3SOCK=~/.config/i3/i3-ipc.sock

exec systemd-cat i3
