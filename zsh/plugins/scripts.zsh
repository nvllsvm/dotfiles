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
