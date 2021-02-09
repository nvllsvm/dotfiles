if [ -d "$NVM_DIR" ]; then
    # holy fuck - nvm.sh nearly triples shell startup time
    # lazy load it!
    _nvm_load=(
        node
        npm
        npx
        nvm
    )

    nvm-load() {
        for cmd in "$_nvm_load[@]"; do
            unalias $cmd
        done
        unset _nvm_load
        unset -f nvm-load
        . "$NVM_DIR/nvm.sh"
    }

    for cmd in "$_nvm_load[@]"; do
        eval "alias $cmd='nvm-load && $cmd'"
    done
fi
