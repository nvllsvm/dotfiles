BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

base16-update() {
    test -d ~/.config/base16-shell || git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
    git --git-dir ~/.config/base16-shell/.git pull
}

update_commands=("$update_commands[@]" base16-update)
