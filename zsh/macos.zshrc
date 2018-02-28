for pkg in {'coreutils','findutils','gnu-sed'}; do
    path=(/usr/local/opt/"${pkg}"/libexec/gnubin "$path[@]")
    manpath+=(/usr/local/opt/"${pkg}"/libexec/gnuman)
done

path=(/usr/local/sbin "$path[@]")
path=(/usr/local/opt/sqlite/bin "$path[@]")
path=("$DOTFILES_DIR/scripts/macos" "$path[@]")

man() {
    MANPATH=$MANPATH /usr/bin/man $@ 1>/dev/null 2>&1
    if [ "$?" -eq 0 ]; then
        MANPATH=$MANPATH /usr/bin/man $@
    else
        /usr/bin/man $@
    fi
}

full-update add brew-update
