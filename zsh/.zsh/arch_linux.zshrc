alias pacman-maid='sudo pacman -Sc --noconfirm && if pacman -Qdtq > /dev/null; then sudo pacman -Rns --noconfirm $(pacman -Qdtq); fi && sudo pacman-optimize'
alias yup='yaourt -Syu --noconfirm --aur && pacman-maid'
alias yup-devel='yaourt -Syu --noconfirm --aur --devel && pacman-maid'
update_commands=("$update_commands[@]" yup-devel)
