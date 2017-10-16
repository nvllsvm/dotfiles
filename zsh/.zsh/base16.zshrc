BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$(bash $BASE16_SHELL/profile_helper.sh)"

base16-update() {
    local repo_dir=~/.config/base16-shell
    local git_dir=$repo_dir/.git
    test -d ~/.config/base16-shell || git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
    git --git-dir $git_dir pull
}


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
