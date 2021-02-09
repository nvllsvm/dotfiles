export PYTHONUSERBASE=~/.local/share/pythonuser

if [ -d "$PYTHONUSERBASE" ]; then
    path=(
        "${PYTHONUSERBASE}/bin"
        "$path[@]"
    )
elif ! command -v python > /dev/null; then
    unset PYTHONUSERBASE
fi
