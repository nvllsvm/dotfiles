BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$(bash $BASE16_SHELL/profile_helper.sh)"

_base16 () {
    local script=$1
    local theme=$2
    [ -f $script ] && . $script
    ln -fs $script ~/.base16_theme
    export BASE16_THEME=${theme}
    echo -e "if \0041exists('g:colors_name') || g:colors_name != 'base16-$theme'\n  colorscheme base16-$theme\nendif" >| ~/.vimrc_background
    load-color-scheme 2> /dev/null || true
}

full-update add base16-update
