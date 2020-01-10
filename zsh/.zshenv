zmodload zsh/stat
export DOTFILES=${$(zstat +link ~/.zshrc)%%/zsh/.zshrc}
export EDITOR=nvim
export LESSHISTFILE=/dev/null
export OPENER=open

zshenv_host="$DOTFILES/zsh/hosts/$HOST/.zshenv"
[[ -r "$zshenv_host" ]] && . "$zshenv_host"
unset zshenv_host
