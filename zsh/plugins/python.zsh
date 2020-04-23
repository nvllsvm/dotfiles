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
    else
        unset PYENV_ROOT
    fi

    path=(
        "${PYTHONUSERBASE}/bin"
        "$path[@]"
    )
elif ! command -v python > /dev/null; then
    unset PYTHONUSERBASE
fi
