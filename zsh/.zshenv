export DOTFILES_DIR=~/Code/GitHub/nvllsvm/dotfiles
export EDITOR=nvim

zshenv_host="$DOTFILES_DIR/zsh/hosts/$HOST/.zshenv"
[[ -r "$zshenv_host" ]] && . "$zshenv_host"
unset zshenv_host
