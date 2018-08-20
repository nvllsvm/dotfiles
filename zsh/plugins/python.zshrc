export PYENV_ROOT=~/.local/git/pyenv
export PYTHONUSERBASE=~/.local/pythonuser

if command -v pyenv > /dev/null; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1

    path=("${DOTFILES_DIR}"/scripts/python  "$path[@]")

    if [[ -d "$PYENV_ROOT" ]]; then
        path=("$PYENV_ROOT/shims" "$PYENV_ROOT/bin" "$path[@]")
        full-update add "pyenv-update"
    fi

    path=("$PYTHONUSERBASE"/bin "$path[@]")

    full-update add pip-update

    # and yet again, flake8's dependencies are out-of-fucking-sync, bah
    full-update add flake8-update
fi
