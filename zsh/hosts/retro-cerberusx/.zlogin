if [ "$XDG_VTNR" -eq 1 ] && [ -z "$TMUX" ] && ! pidof tmux > /dev/null; then
	unset MOTD_SHOWN
	exec tmux-attach
fi
if [ -z "$MOTD_SHOWN" ]; then
	cat /etc/motd
	export MOTD_SHOWN=zlogin
fi
