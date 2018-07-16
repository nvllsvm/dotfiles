export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

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

# roughly match util-linux
uuidgen() {
    if [ "$#" -eq 0 ]; then
        /usr/bin/uuidgen | tr "[:upper:]" "[:lower:]"
    else
        /usr/bin/uuidgen "$@"
    fi
}


full-update add brew-update
