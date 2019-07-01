if [ -d "$HOME/.cargo/bin" ]; then
    path+=(
        "$HOME/.cargo/bin"
        "$path[@]"
    )
    full-update add 'rustup update'
fi
