path=(
    "${DOTFILES_DIR}"/scripts/terminal
    "${DOTFILES_DIR}"/scripts/media
    "${DOTFILES_DIR}"/scripts/rabbitmq
    "${DOTFILES_DIR}"/scripts/desktop
    "$path[@]"
)

host_scripts="${DOTFILES_DIR}/scripts/hosts/$HOST"
if [ -d "$host_scripts" ]; then
    path=("$host_scripts" "$path[@]")
fi
unset host_scripts

full-update add 'srvit --pull'
