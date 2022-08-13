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
ln -fnsv $HOME/dotfiles/gitmessage $HOME/.gitmessage
# editorconfig
ln -fnsv $HOME/dotfiles/.editorconfig $HOME/.editorconfig

#########
# Vim library
#########
# defx
# pip3 install neovim
pip3 install --user pynvim

#########
# Node.js
#########
npm i -g bash-language-server
npm install mdpdf -g
npm install -g yarn
npm install -g aws-cdk
# nvmに移行したい

#########
# Go library
#########
# mmv
go install github.com/itchyny/mmv/cmd/mmv@latest
# germanium(require go1.16)
git clone https://github.com/matsuyoshi30/germanium $GOPATH/src/github.com/germanium
cd $GOPATH/src/github.com/germanium/cmd/germanium && go install
# fzwiki
git clone https://github.com/sheepla/fzwiki.git $GOPATH/src/github.com/fzwiki
cd $GOPATH/src/github.com/sheepla/fzwiki && go install
# lazygit
go install github.com/jesseduffield/lazygit@latest
# ojosama
go install github.com/jiro4989/ojosama/cmd/ojosama@latest
# godoc
go install golang.org/x/tools/cmd/godoc@latest
# gojson
go install github.com/ChimeraCoder/gojson/gojson@latest
# stringer
go install golang.org/x/tools/cmd/stringer@latest
# errcheck
go install github.com/kisielk/errcheck@latest
# golangci-lint-langserver
go install github.com/nametake/golangci-lint-langserver@latest
# sqlc
go install github.com/kyleconroy/sqlc/cmd/sqlc@latest
# sqlboiler
go install github.com/volatiletech/sqlboiler/v4@latest
go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-psql@latest
# swag(go-swagger)
go install github.com/swaggo/swag/cmd/swag@latest
# oapi-codegen(go-openapi)
go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest

#########
# Rust
#########
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# bat
cargo install --locked bat
# silicon
cargo install silicon
# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

#########
# Must tools
#########

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# zplug
ZPLUG_HOME=$HOME/.zplug
git clone https://github.com/zplug/zplug $ZPLUG_HOME

# navi
git clone https://github.com/denisidoro/navi ~/.navi
cd ~/.navi
make install
mkdir $HOME/.config/navi
ln -fnsv $HOME/dotfiles/navi/config.yaml $HOME/.config/navi/config.yaml

# tmux
# TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#########
# deno
#########
curl -fsSL https://deno.land/x/install/install.sh | sh

#########
# elm
#########
npm install -g elm
npm install -g elm-format
npm install -g @elm-tooling/elm-language-server

###
# vifm
###
mkdir $HOME/.vifm
ln -fnsv $HOME/dotfiles/vifmrc $HOME/.vifm

###
# awk
###
mkdir $HOME/mybin
wget -O $HOME/mybin/trans git.io/trans
chmod +x $HOME/mybin/trans

# git-now
git clone --recursive git://github.com/iwata/git-now.git $HOME/.git-now
sudo make install

# git hooks pre-push
ln -fnsv $HOME/dotfiles/git_template $HOME/.git_template

###
# Git
###

# git-secrets
git clone git@github.com:awslabs/git-secrets.git $GOPATH/src/github.com/awslabs/git-secrets
cd $GOPATH/src/github.com/awslabs/git-secrets
sudo make install
cd --
