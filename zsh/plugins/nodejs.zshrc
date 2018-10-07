export NVM_DIR=~/.local/git/nvm

if [ -d "$NVM_DIR" ]; then
    # holy fuck nvm.sh nearly triples shell startup time
    # lazy load that piece of shit
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
        alias $cmd="nvm-load && $cmd"
    done

    path=("${DOTFILES}/scripts/nodejs" "$path[@]")
    full-update add nvm-update
else
    unset NVM_DIR
fi
