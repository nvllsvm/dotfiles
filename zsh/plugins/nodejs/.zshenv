export NVM_DIR=~/.local/share/nvm

if [ -d "$NVM_DIR" ]; then
    path=(
        "${DOTFILES}/scripts/nvm"
        "${NVM_DIR}/current/bin"
        "$path[@]"
    )
else
    unset NVM_DIR
fi
