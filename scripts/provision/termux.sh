#!/bin/sh
set -e
export HOME=/data/data/com.termux/files/home
export DOTFILES_DIR=$HOME/Code/GitHub/nvllsvm/dotfiles
pkg update
pkg install \
    clang \
    curl \
    git \
    libcrypt-dev \
    neovim \
    openssh \
    python-dev \
    ranger \
    termux-api \
    tmux \
    zsh

pip install neovim 

chsh -s zsh

mkdir -p ${HOME}/Code/GitHub/nvllsvm
git clone https://github.com/nvllsvm/dotfiles.git "${DOTFILES_DIR}"
ln -s "${DOTFILES_DIR}"/zsh/hosts/termux/.zshlocal ${HOME}
ln -s "${DOTFILES_DIR}"/zsh/.zshrc ${HOME}
ln -s "${DOTFILES_DIR}"/zsh/.zshenv ${HOME}

mkdir -p ${HOME}/.config
ln -s "${DOTFILES_DIR}"/neovim/ ${HOME}/.config/nvim

mkdir -p ${HOME}/.bin
ln -s "${DOTFILES_DIR}"/scripts/terminal ${HOME}/.bin
ln -s "${DOTFILES_DIR}"/scripts/tmux ${HOME}/.bin
ln -s "${DOTFILES_DIR}"/scripts/syncthing ${HOME}/.bin

ln -s ${HOME}/storage/Syncthing ${HOME}/Syncthing

ln -s ${HOME}/.config/base16-shell/scripts/base16-bright.sh ${HOME}/.base16_theme

mv ${HOME}/storage/shared ${HOME}/shared
rm -rf ${HOME}/storage
mv ${HOME}/shared ${HOME}/storage

rm $HOME/../usr/etc/motd
