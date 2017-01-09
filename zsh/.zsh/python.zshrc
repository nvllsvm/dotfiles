if $(test $(command -v python2)); then
    path=("$(python2 -m site --user-base)/bin"  "$path[@]")

    alias pip2-update='pip2 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip2 install --user -U'
    update_commands=("$update_commands[@]" pip2-update)
fi

if $(test $(command -v python3)); then
    path=("$(python3 -m site --user-base)/bin"  "$path[@]")

    alias pip3-update='pip3 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install --user -U'
    update_commands=("$update_commands[@]" pip3-update)
fi
