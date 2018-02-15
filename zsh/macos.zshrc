path=(/usr/local/opt/coreutils/libexec/gnubin "$path[@]")
manpath=(/usr/local/opt/coreutils/libexec/gnuman "$manpath[@]")

path=(/usr/local/sbin "$path[@]")
path=(/usr/local/opt/sqlite/bin "$path[@]")
path=("$DOTFILES_DIR/scripts/macos" "$path[@]")

alias brew-update='brew update && brew upgrade && brew cask upgrade && brew cleanup'

full-update add brew-update
