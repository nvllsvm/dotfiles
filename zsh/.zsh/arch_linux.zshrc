alias pacman-maid='sudo pacman -Sc --noconfirm && if pacman -Qdtq > /dev/null; then sudo pacman -Rns --noconfirm $(pacman -Qdtq); fi && sudo pacman-optimize'
alias yup='yaourt -Syu --noconfirm --aur --devel'
alias ssh='TERM=xterm-256color ssh'

full-update add yup
