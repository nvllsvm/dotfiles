if [ -d ~/go ]; then
    path=(
        "$HOME/go/bin"
        "$path[@]"
    )
fi
