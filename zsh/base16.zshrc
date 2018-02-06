BASE16_SHELL=$HOME/.config/base16-shell/

if [[ -z $SSH_TTY ]] || [[ $BASE16_ENABLE ]]; then
    [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$(bash $BASE16_SHELL/profile_helper.sh)"
    unset BASE16_THEME
fi

_base16 () {
    local script=$1
    local theme=$2
    [ -f $script ] && . $script
    ln -fs $script ~/.base16_theme
    echo -e "if \0041exists('g:colors_name') || g:colors_name != 'base16-$theme'\n  colorscheme base16-$theme\nendif" >| ~/.vimrc_background
    load-xresources-theme 2> /dev/null || true
    rm ~/.vimrc_background
}

path=("$DOTFILES_DIR"/scripts/base16 "$path[@]")

full-update add base16-update
