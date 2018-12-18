export GOENV_ROOT=~/.local/git/goenv

if [ -d "$GOENV_ROOT" ]; then
    path=(
        "$DOTFILES/scripts/go"
        "$GOENV_ROOT/bin"
        "~/go/bin"
        "$path[@]"
    )

    full-update add goenv-update
else
    unset GOENV_ROOT
fi
