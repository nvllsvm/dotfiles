if $(test $(command -v python2)); then
    alias pip2-update='pip2 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip2 install --user -U'
    path=("$(python2 -m site --user-base)/bin"  "$path[@]")
fi

if $(test $(command -v python3)); then
    alias pip3-update='pip3 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install --user -U'
    path=("$(python3 -m site --user-base)/bin"  "$path[@]")
fi
