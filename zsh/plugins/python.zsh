export PYTHONUSERBASE=~/.local/pythonuser

if [ -d "$PYTHONUSERBASE" ]; then
    export PYENV_ROOT=~/.local/share/pyenv
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

    path=(
        "${PYTHONUSERBASE}/bin"
        "$path[@]"
    )

    . ~/.local/share/pipns/shell.sh &> /dev/null || true

    full-update add pip-update
    full-update add pipns-update
    full-update add 'venv --prune'
else
    unset PYTHONUSERBASE
fi
