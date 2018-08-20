export PYENV_ROOT=~/.local/git/pyenv

if [[ -d "$PYENV_ROOT" ]]; then
    export PYTHONUSERBASE=~/.local/pythonuser

    path=("$PYENV_ROOT/shims" "$PYENV_ROOT/bin" "$path[@]")
    full-update add "pyenv-update"

    export VIRTUAL_ENV_DISABLE_PROMPT=1

    path=("${DOTFILES_DIR}"/scripts/python  "$path[@]")

    path=("$PYTHONUSERBASE"/bin "$path[@]")

    full-update add pip-update

    # and yet again, flake8's dependencies are out-of-fucking-sync, bah
    full-update add flake8-update
else
    unset PYENV_ROOT
fi
