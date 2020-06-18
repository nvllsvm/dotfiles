if [[ $OSTYPE == darwin* ]]; then
    export LANG=en_US.UTF-8
    export HOMEBREW_NO_ANALYTICS=1

    manpath=(/usr/local/share/man /usr/share/man "$manpath[@]")
    for pkg in coreutils diffutils findutils gawk gnu-sed gnu-tar grep; do
        path=(/usr/local/opt/"${pkg}"/libexec/gnubin "$path[@]")
        manpath=(/usr/local/opt/"${pkg}"/libexec/gnuman "$manpath[@]")
    done

    path=(
        "$DOTFILES/scripts/macos"
        /usr/local/opt/curl/bin
        /usr/local/opt/sqlite/bin
        /usr/local/sbin
        "$path[@]"
    )

    man() {
        /usr/bin/man "$@" 2> /dev/null
    }
fi
