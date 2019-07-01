export PYENV_ROOT=~/.local/git/pyenv

if [ -d "$PYENV_ROOT" ]; then
    export PYTHONUSERBASE=~/.local/pythonuser

    path=(
        "${DOTFILES}/scripts/python"
        "${PYTHONUSERBASE}/bin"
        "${PYENV_ROOT}/bin"
        "${PYENV_ROOT}/shims"
        "$path[@]"
    )

    . ~/.local/share/pipns/shell.sh &> /dev/null || true

    full-update add pyenv-update
    full-update add pip-update
    full-update add pipns-update
    full-update add 'venv --prune'
else
    unset PYENV_ROOT
fi
