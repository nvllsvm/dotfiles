export PYTHONUSERBASE=~/.local/share/pythonuser

if [ -d "$PYTHONUSERBASE" ]; then
    path=(
        "${PYTHONUSERBASE}/bin"
        "$path[@]"
    )
    # the defaults are fucking bullshit and break shit like poetry.
    # ffs, the python packing system is still mentally inept in 2022
    # https://github.com/python-poetry/poetry/issues/1917#issuecomment-1235998997
    export PYTHON_KEYRING_BACKEND='keyring.backends.null.Keyring'

elif ! command -v python > /dev/null; then
    unset PYTHONUSERBASE
fi
