if command -v nvim > /dev/null; then
    alias view="nvim -R"

    nvim-update() {
        if [[ ! -f ~/.config/nvim/autoload/plug.vim ]]; then
            curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi
        nvim -c 'PlugUpgrade | PlugUpdate | PlugClean | silent UpdateRemotePlugins' -c 'qa'
    }


    nvim() {
        local nvim=$(whence -p nvim)
        if [ -f env/bin/python ]; then
            VIRTUAL_ENV="$(readlink -f env)" $nvim "$@"
        else
            $nvim "$@"
        fi
    }


    full-update add nvim-update
fi
