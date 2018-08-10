export PYENV_ROOT=~/.pyenv
export PYTHONUSERBASE=~/.pythonuser
export VIRTUAL_ENV_DISABLE_PROMPT=1

path=("${DOTFILES_DIR}"/scripts/python  "$path[@]")

if [[ -d "$PYENV_ROOT" ]]; then
    path=("$PYENV_ROOT/shims" "$PYENV_ROOT/bin" "$path[@]")
    full-update add "pyenv-update"
fi

path=("$PYTHONUSERBASE"/bin "$path[@]")

full-update add "pip-update pip-user"

# and yet again, flake8's dependencies are out-of-fucking-sync, bah
full-update add "pip-user install flake8"
