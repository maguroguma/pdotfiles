# change default shell
chsh -s /bin/zsh

#########
# symbolic links
#########
ln -fnsv $HOME/dotfiles/zshrc $HOME/.zshrc
ln -fnsv $HOME/dotfiles/zsh.d $HOME/.zsh.d
ln -fnsv $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
ln -fnsv $HOME/dotfiles/nvim $HOME/.config/nvim
ln -fnsv $HOME/dotfiles/gitconfig $HOME/.gitconfig
ln -fnsv $HOME/dotfiles/gitignore $HOME/.gitignore
ln -fnsv $HOME/dotfiles/gitmessage $HOME/.gitmessage
ln -fnsv $HOME/dotfiles/.editorconfig $HOME/.editorconfig
ln -fnsv $HOME/dotfiles/git_template $HOME/.git_template

mkdir $HOME/.vifm
ln -fnsv $HOME/dotfiles/vifmrc $HOME/.vifm

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

# tmux(tpm)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# deno
curl -fsSL https://deno.land/x/install/install.sh | sh

# trans
mkdir $HOME/mybin
wget -O $HOME/mybin/trans git.io/trans
chmod +x $HOME/mybin/trans

# git-secrets
git clone git@github.com:awslabs/git-secrets.git $GOPATH/src/github.com/awslabs/git-secrets
cd $GOPATH/src/github.com/awslabs/git-secrets
sudo make install
cd --

# jetpack(neovim)
curl -fLo ~/.local/share/nvim/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim \
    --create-dirs https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim

#########
# go install
#########
go install github.com/itchyny/mmv/cmd/mmv@latest
go install github.com/jesseduffield/lazygit@latest
go install golang.org/x/tools/cmd/godoc@latest
go install github.com/ChimeraCoder/gojson/gojson@latest
go install golang.org/x/tools/cmd/stringer@latest
go install github.com/kisielk/errcheck@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/kyleconroy/sqlc/cmd/sqlc@latest
go install github.com/volatiletech/sqlboiler/v4@latest
go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-psql@latest
go install github.com/swaggo/swag/cmd/swag@latest
go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest
go install github.com/ddddddO/gtree/cmd/gtree@latest
go install github.com/k0kubun/sqldef/cmd/mysqldef@latest
go install github.com/mattn/chatgpt@latest
go install github.com/mattn/memo@latest

#########
# Rust(cargo)
#########
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install --locked bat
cargo install silicon
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

#########
# Node.js
#########
npm i -g bash-language-server
npm install mdpdf -g
npm install -g yarn
npm install -g aws-cdk
