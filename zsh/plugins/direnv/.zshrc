if command -v direnv > /dev/null; then
    # lazy load to avoid potential slowdown on remote filesystems
    direnv() {
        unset -f direnv
        eval "$(direnv hook zsh)"

        export DIRENV_LOG_FORMAT=

        direnv_indicator() {
            if [[ -z $DIRENV_DIR ]] then
                unset prompt_direnv
            else
                prompt_direnv="(direnv)"
            fi
        }

        add-zsh-hook precmd direnv_indicator

        PROMPT='$prompt_direnv'"$PROMPT"
        direnv "$@"
    }
fi
