path=("${DOTFILES_DIR}"/scripts/python  "$path[@]")

if [[ -d ~/.pyenv ]]; then
    export PYENV_ROOT=~/.pyenv
    path=("$PYENV_ROOT/bin" "$path[@]")
    full-update add "pyenv-setup"
fi

if $(test $(command -v python3)); then
    path=("$(python3 -m site --user-base)/bin"  "$path[@]")

    if $(test $(command -v pip)); then
        full-update add "pip-update pip-user"

        # and yet again, flake8's dependencies are out-of-fucking-sync, bah
        full-update add "pip-user install flake8"
    fi
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1
