if [[ $OSTYPE == darwin* ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export HOMEBREW_NO_ANALYTICS=1

    for pkg in coreutils diffutils findutils gawk gnu-sed gnu-tar grep; do
        path=(/usr/local/opt/"${pkg}"/libexec/gnubin "$path[@]")
        manpath=(/usr/local/opt/"${pkg}"/libexec/gnuman "$manpath[@]")
    done

    path=(/usr/local/sbin "$path[@]")
    path=(/usr/local/opt/sqlite/bin "$path[@]")
    path=(/usr/local/opt/curl/bin "$path[@]")
    path=("$DOTFILES/scripts/macos" "$path[@]")

    man() {
        MANPATH=$MANPATH /usr/bin/man $@ 1>/dev/null 2>&1
        if [ "$?" -eq 0 ]; then
            MANPATH=$MANPATH /usr/bin/man $@ 2> /dev/null
        else
            /usr/bin/man $@ 2> /dev/null
        fi
    }

    full-update add brew-update
fi
