if [[ $OSTYPE == darwin* ]]; then
    # what the fucking-fuck is Apple overriding PATH for in /etc/zprofile?
    # Apple, go fuck yourself.
    setopt no_global_rcs

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
        /usr/local/opt/*/libexec/gnubin
        /usr/local/sbin
        "$path[@]"
    )

    fpath=(
        /usr/local/opt/*/share/zsh/site-functions
        "$fpath[@]"
    )
fi
