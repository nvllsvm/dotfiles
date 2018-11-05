export PYENV_ROOT=~/.local/git/pyenv

if [[ -d "$PYENV_ROOT" ]]; then
    export PYTHONUSERBASE=~/.local/pythonuser

    path=(
        "${DOTFILES}/scripts/python"
        "${PYTHONUSERBASE}/bin"
        "${PYENV_ROOT}/bin"
        "${PYENV_ROOT}/shims"
        "$path[@]"
    )

    full-update add pyenv-update
    full-update add 'PIP_REQUIRE_VIRTUALENV=0 pip-update'
    full-update add piptfo-update
else
    unset PYENV_ROOT
fi
