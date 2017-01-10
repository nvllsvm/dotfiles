if $(test $(command -v python2)); then
    path=("$(python2 -m site --user-base)/bin"  "$path[@]")

    alias pip2-update='pip2 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip2 install --user -U'
    update_commands=("$update_commands[@]" pip2-update)

    fn venv2() {
        if [[ -z $1 ]]; then
            env="env2"
        else
            env=$1
        fi

        if [[ ! -d $env ]]; then
            virtualenv -p python2 $env
        fi

        source $env/bin/activate
    }
fi

if $(test $(command -v python3)); then
    path=("$(python3 -m site --user-base)/bin"  "$path[@]")

    alias pip3-update='pip3 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install --user -U'
    update_commands=("$update_commands[@]" pip3-update)

    fn venv3() {
        if [[ -z $1 ]]; then
            env="env3"
        else
            env=$1
        fi

        if [[ ! -d $env ]]; then
            virtualenv -p python3 $env
        fi

        source $env/bin/activate
    }
fi
