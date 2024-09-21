if [ "$XDG_VTNR" -eq 1 ] && ! pidof tmux > /dev/null; then
	exec tmux-attach
fi
