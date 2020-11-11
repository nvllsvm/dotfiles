if [[ $OSTYPE == darwin* ]]; then
    export LANG=en_US.UTF-8
    export HOMEBREW_NO_ANALYTICS=1

    manpath=(
        /usr/local/opt/*/libexec/gnuman
        /usr/local/share/man
        /usr/share/man
        "$manpath[@]"
    )

    path=(
        "$DOTFILES/scripts/macos"
        /usr/local/opt/curl-openssl/bin
        /usr/local/opt/file-formula/bin
        /usr/local/opt/sqlite/bin
        /usr/local/sbin
        /usr/local/opt/*/libexec/gnubin "$path[@]"
        "$path[@]"
    )

    man() {
        /usr/bin/man "$@" 2> /dev/null
    }
fi
