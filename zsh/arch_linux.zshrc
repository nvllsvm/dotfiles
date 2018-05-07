alias pacman-maid='sudo pacman -Sc --noconfirm && if pacman -Qdtq > /dev/null; then sudo pacman -Rns --noconfirm $(pacman -Qdtq); fi && sudo pacman-optimize'
alias ssh='TERM=xterm-256color ssh'
alias pacman-update-mirrors='sudo reflector --verbose --sort rate -a 1 -n 30 --save /etc/pacman.d/mirrorlist'
alias trizen-install='trizen -S --noedit --noconfirm'

full-update add 'trizen -Syu --devel --noconfirm --noedit --needed'
