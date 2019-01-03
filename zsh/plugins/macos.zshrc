if [[ $OSTYPE == darwin* ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    for pkg in {'coreutils','diffutils','findutils','gnu-sed','grep'}; do
        path=(/usr/local/opt/"${pkg}"/libexec/gnubin "$path[@]")
        manpath+=(/usr/local/opt/"${pkg}"/libexec/gnuman)
    done

    path=(/usr/local/sbin "$path[@]")
    path=(/usr/local/opt/sqlite/bin "$path[@]")
    path=(/usr/local/opt/curl/bin "$path[@]")
    path=("$DOTFILES/scripts/macos" "$path[@]")

    man() {
        MANPATH=$MANPATH /usr/bin/man $@ 1>/dev/null 2>&1
        if [ "$?" -eq 0 ]; then
            MANPATH=$MANPATH /usr/bin/man $@
        else
            /usr/bin/man $@
        fi
    }

    full-update add brew-update
    full-update add dash-install
    full-update add nvim-nightly-install
fi
