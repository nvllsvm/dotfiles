path=("${DOTFILES_DIR}"/scripts/python  "$path[@]")

venv() {
    local env_folder=$1
    local python_bin=$2

    if [[ -z $env_folder ]]; then
        env_folder=env
    fi

    if [[ -z $python_bin ]]; then
        python_bin=python3
    fi

    if [[ ! -d $env_folder ]]; then
        virtualenv -p $python_bin $env_folder
        if [[ $? -ne 0 ]]; then
            rm -r $env_folder
            return 1
        fi
    fi

    echo . $env_folder/bin/activate > .envrc

    direnv allow
    direnv reload
}

if $(test $(command -v python3)); then
    path=("$(python3 -m site --user-base)/bin"  "$path[@]")

    if $(test $(command -v pip)); then
        full-update add "pip-update pip-user"
    fi
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1
