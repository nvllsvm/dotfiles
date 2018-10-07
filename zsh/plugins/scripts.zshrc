path=(
    "${DOTFILES}"/scripts/terminal
    "${DOTFILES}"/scripts/media
    "${DOTFILES}"/scripts/rabbitmq
    "${DOTFILES}"/scripts/desktop
    "$path[@]"
)

host_scripts="${DOTFILES}/scripts/hosts/$HOST"
if [ -d "$host_scripts" ]; then
    path=("$host_scripts" "$path[@]")
fi
unset host_scripts
