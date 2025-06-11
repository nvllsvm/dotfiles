if [[ $OSTYPE == darwin* ]]; then
    # ugh - Apple overrides PATH in /etc/zprofile
    # disable that bullshit and update PATH here
    # (normally runs: eval `/usr/libexec/path_helper -s`)
    setopt no_global_rcs
    path=(
        /usr/local/bin
        "$path[@]"
        /Library/Apple/usr/bin
    )

    export LANG=en_US.UTF-8
    export HOMEBREW_NO_ANALYTICS=1

    setopt no_nomatch
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
    setopt nomatch
fi
