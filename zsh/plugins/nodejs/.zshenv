export NVM_DIR=~/.local/share/nvm

if [ -d "$NVM_DIR" ]; then
    path=(
        "${DOTFILES}/scripts/nvm"
        "$path[@]"
    )
else
    unset NVM_DIR
fi
