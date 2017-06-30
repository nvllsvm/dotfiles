path=(/usr/local/opt/coreutils/libexec/gnubin "$path[@]")
manpath=(/usr/local/opt/coreutils/libexec/gnuman "$manpath[@]")

alias brew-update='brew update && brew upgrade'

full-update add brew-update
