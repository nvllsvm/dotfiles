pushd "$DOTFILES/scripts/commands" > /dev/null
for c in *; do
    if command -v "$c" > /dev/null; then
        path=("$DOTFILES/scripts/commands/$c" "$path[@]")
    fi
done
popd > /dev/null

path=(
    "${DOTFILES}"/scripts/terminal
    "${DOTFILES}"/scripts/bullshit
    "$path[@]"
)

host_scripts="${DOTFILES}/scripts/hosts/$HOST"
if [ -d "$host_scripts" ]; then
    path=("$host_scripts" "$path[@]")
fi
unset host_scripts
