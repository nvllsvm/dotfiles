if command -v pacman > /dev/null; then
    alias ssh='TERM=xterm-256color ssh'
    alias pacman-update-mirrors='sudo reflector --verbose --sort rate -a 1 -n 30 --save /etc/pacman.d/mirrorlist'

    archlinux-update() {
        yay -Syu --noconfirm
        asp update 
        sudo pkgfile --update

        sudo pacman -Sc --noconfirm 
        if pacman -Qdtq > /dev/null; then 
            sudo pacman -Rns --noconfirm $(pacman -Qdtq)
        fi
    }

    full-update add 'archlinux-update'
fi
