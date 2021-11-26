#!/bin/bash

# change default shell
chsh -s /bin/zsh

#########
# symbolic links
#########
# zsh
ln -fnsv $HOME/dotfiles/zshrc $HOME/.zshrc
ln -fnsv $HOME/dotfiles/zsh.d $HOME/.zsh.d
# fzf
ln -fnsv $HOME/dotfiles/fzf.zsh $HOME/.fzf.zsh
# tmux
ln -fnsv $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
# vim
#ln -fnsv $HOME/dotfiles/.vimrc $HOME/.vimrc
# nvim
ln -fnsv $HOME/dotfiles/nvim $HOME/.config/nvim
# git
ln -fnsv $HOME/dotfiles/gitconfig $HOME/.gitconfig
ln -fnsv $HOME/dotfiles/gitignore $HOME/.gitignore

#########
# Vim library
#########
# denite
pip3 install neovim
# LSP servers
npm i -g bash-language-server

###
# vifm
###
mkdir $HOME/.vifm
ln -fnsv $HOME/dotfiles/vifmrc $HOME/.vifm
