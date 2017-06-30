nvim-update() {
    if [[ ! -f ~/.config/nvim/autoload/plug.vim ]]; then
        curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    nvim -c 'PlugUpgrade | PlugUpdate | PlugClean | silent UpdateRemotePlugins' -c 'qa'
}
full-update add nvim-update
