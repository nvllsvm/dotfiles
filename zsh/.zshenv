zmodload zsh/stat
export DOTFILES_DIR=${$(zstat +link ~/.zshrc)%%zsh/.zshrc}
export EDITOR=nvim

zshenv_host="$DOTFILES_DIR/zsh/hosts/$HOST/.zshenv"
[[ -r "$zshenv_host" ]] && . "$zshenv_host"
unset zshenv_host
