export GOENV_ROOT=$HOME/.local/git/goenv

if [ -d "$GOENV_ROOT" ]; then
    path=(
        "$DOTFILES/scripts/go"
        "$GOENV_ROOT/bin"
        "$HOME/go/bin"
        "$path[@]"
    )

    full-update add goenv-update
else
    unset GOENV_ROOT
fi
