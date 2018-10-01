BASE16_SHELL=$HOME/.local/git/base16-shell/

if [ -d "$BASE16_SHELL" ]; then
    if [[ -z $SSH_TTY ]] && [[ -z $TMUX ]]; then
        if [ -f ~/.base16_theme ]; then
          . ~/.base16_theme
        fi
    fi

    for script in $BASE16_SHELL/scripts/base16*.sh; do
      script_name=${script##*/}
      script_name=${script_name%.sh}
      theme=${script_name#*-}
      alias "base16_${theme}"="_base16 $script"
    done;

    _base16 () {
        ln -fs $1 ~/.base16_theme
        . ~/.base16_theme
        load-xresources-theme 2> /dev/null || true
    }

    path=("$DOTFILES_DIR"/scripts/base16 "$path[@]")

    full-update add base16-update
else
    unset BASE16_SHELL
fi
