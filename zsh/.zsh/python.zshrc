pip-update() {
    local python_version=$1
    local packages=`pip$python_version list --outdated --format=freeze`

    if [[ ! -z $packages ]]; then
        echo $packages | grep -v '^\-e' | cut -d = -f 1 | xargs pip$python_version install --upgrade
    else
        echo All Python $python_version packages up-to-date.
    fi
}

python-site-build() {
    local python_version=$1
    local site_dir=$(python$python_version -m site --user-site)
    if [[ ! -d $site_dir ]]; then
        mkdir -p $site_dir
        touch "$site_dir/.pth"

        cd $(python$python_version -m site --user-base)
        curl -O https://bootstrap.pypa.io/get-pip.py
        python$python_version get-pip.py --user --force
        rm get-pip.py
    fi
}

venv() {
    local python_version=$1

    if [[ -z $python_version ]]; then
        python_version=3
    fi

    if [[ ! -d env ]]; then
        virtualenv -p python$python_version env
    fi

    source env/bin/activate
}

if $(test $(command -v python2.7)); then
    path=("$(python2.7 -m site --user-base)/bin"  "$path[@]")

    if $(test $(command -v pip2)); then
        alias pip2-update='pip-update 2'
        update_commands=("$update_commands[@]" pip2-update)
    fi
fi

if $(test $(command -v python3)); then
    path=("$(python3 -m site --user-base)/bin"  "$path[@]")

    if $(test $(command -v pip3)); then
        alias pip3-update='pip-update 3'
        update_commands=("$update_commands[@]" pip3-update)
    fi
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1

PYTHON3_BIN=$(command -v python3)

function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]] then
        unset prompt_virtualenv
        unset SYSTEM_PYTHON3_BIN
        unset PIP_USER
    else
        prompt_virtualenv="($(basename $VIRTUAL_ENV))"

        if [[ -n $PYTHON3_BIN ]] then
            export SYSTEM_PYTHON3_BIN=$PYTHON3_BIN
        fi

        export PIP_USER=0
    fi
}

add-zsh-hook precmd virtenv_indicator

PROMPT='$prompt_virtualenv'"$PROMPT"
