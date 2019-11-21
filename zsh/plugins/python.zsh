export PYTHONUSERBASE=~/.local/share/pythonuser
export PYENV_ROOT=~/.local/share/pyenv

if [ -d "$PYENV_ROOT" ] || [ -d "$PYTHONUSERBASE" ]; then
    if [ -d "$PYENV_ROOT" ]; then
        path=(
            "${PYENV_ROOT}/plugins/pyenv-global-links"
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

    full-update add pip-update
    full-update add 'venv --prune'
elif ! command -v python > /dev/null; then
    unset PYTHONUSERBASE
fi
