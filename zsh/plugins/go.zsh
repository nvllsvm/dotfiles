if [ -d ~/go/bin ]; then
    path=(
        "$HOME/go/bin"
        "$path[@]"
    )
fi
