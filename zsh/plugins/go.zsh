if [ -d ~/go ]; then
    path=(
        "$HOME/go/bin"
        "$path[@]"
    )
fi

export GOENV_ROOT=$HOME/.local/share/goenv

if [ -d "$GOENV_ROOT" ]; then
    path=(
        "$GOENV_ROOT/bin"
        "$path[@]"
    )

    full-update add goenv-update
else
    unset GOENV_ROOT
fi
