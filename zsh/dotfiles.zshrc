dotfiles-update() {
    git-auto-update $DOTFILES_DIR
    etc-backup-desktop
}

full-update add dotfiles-update
