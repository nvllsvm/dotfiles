if [ -d ~/go/bin ]; then
    path=(
        ~/go/bin
        "$path[@]"
    )
fi
