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

for version in {'2.7','3'}; do
    if $(test $(command -v python$version)); then
        path=("$(python$version -m site --user-base)/bin"  "$path[@]")

        if $(test $(command -v pip$version)); then
            full-update add "pip-update $version"
        fi
    fi
done

export VIRTUAL_ENV_DISABLE_PROMPT=1

add-zsh-hook precmd virtenv_indicator

alias tox='PIP_USER=0 tox'

PROMPT='$prompt_virtualenv'"$PROMPT"
