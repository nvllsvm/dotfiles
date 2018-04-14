venv() {
    local python_version=$1
    local folder=env

    if [[ -z $python_version ]]; then
        python_version=3
    fi

    if [[ ! -d $folder ]]; then
        virtualenv -p python$python_version $folder
        if [[ $? -ne 0 ]]; then
            rm -r $folder
            return 1
        fi
    fi

    if [[ -e $folder/bin/activate ]]; then
        source $folder/bin/activate
    else
        echo Invalid virtualenv
        return 1
    fi
}

virtenv_indicator() {
    if [[ -z $VIRTUAL_ENV ]] then
        unset prompt_virtualenv
        unset PIP_USER
        unset PYTHONPATH
    else
        prompt_virtualenv="($(basename $VIRTUAL_ENV))"
        export PIP_USER=0
        export PYTHONPATH=$VIRTUAL_ENV
    fi
}

if $(test $(command -v python3)); then
    path=("$(python3 -m site --user-base)/bin"  "$path[@]")

    if $(test $(command -v pip-user)); then
        full-update add "pip-update pip-user"
    fi
fi

path=("${DOTFILES_DIR}"/scripts/python  "$path[@]")

export VIRTUAL_ENV_DISABLE_PROMPT=1

add-zsh-hook precmd virtenv_indicator

PROMPT='$prompt_virtualenv'"$PROMPT"
