export PYTHONUSERBASE=~/.local/share/pythonuser
export PYENV_ROOT=~/.local/share/pyenv

if [ -d "$PYENV_ROOT" ] || [ -d "$PYTHONUSERBASE" ]; then
    path=(
        "${PYTHONUSERBASE}/bin"
        "$path[@]"
    )

    if [ -d "$PYENV_ROOT" ]; then
        path=(
            "${PYENV_ROOT}/bin"
            "${PYENV_ROOT}/shims"
            "$path[@]"
        )
        full-update add pyenv-update
    else
        unset PYENV_ROOT
    fi

    . ~/.local/share/pipns/shell.sh &> /dev/null || true

    full-update add pip-update
    full-update add pipns-update
    full-update add 'venv --prune'
elif ! command -v python > /dev/null; then
    unset PYTHONUSERBASE
fi
