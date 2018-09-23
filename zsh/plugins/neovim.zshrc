if command -v nvim > /dev/null; then
    alias view="nvim -R"

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
