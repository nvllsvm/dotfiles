export PYENV_ROOT=~/.local/git/pyenv

if [[ -d "$PYENV_ROOT" ]]; then
    export PYTHONUSERBASE=~/.local/pythonuser
    export VIRTUAL_ENV_DISABLE_PROMPT=1

    path=(
        "${DOTFILES_DIR}/scripts/python"
        "${PYTHONUSERBASE}/bin"
        "${PYENV_ROOT}/bin"
        "${PYENV_ROOT}/shims"
        "$path[@]"
    )

    full-update add pyenv-update
    full-update add pip-update

    # and yet again, flake8's dependencies are out-of-fucking-sync, bah
    full-update add flake8-update
else
    unset PYENV_ROOT
fi
