path=(/usr/local/opt/coreutils/libexec/gnubin "$path[@]")
manpath=(/usr/local/opt/coreutils/libexec/gnuman "$manpath[@]")

path=(/usr/local/opt/sqlite/bin "$path[@]")

alias brew-update='brew update && brew upgrade && brew cleanup'

full-update add brew-update
