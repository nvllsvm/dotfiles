. $HOME/.zshrc

if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
//	startx &> /dev/null &
	startx
//  startx-awesome
	logout
fi
