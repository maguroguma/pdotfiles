# change default shell
chsh -s /bin/zsh

# temporary alias
DOTFILES_DIR=$HOME/dotfiles
XDG_CONFIG_HOME=$HOME/.config
XDG_DATA_HOME="$HOME/.local/share"

#########
# symbolic links
#########
ln -fnsv $DOTFILES_DIR/.zshenv $HOME/.zshenv
ln -fnsv $DOTFILES_DIR/zsh $XDG_CONFIG_HOME/zsh
ln -fnsv $DOTFILES_DIR/tmux $XDG_CONFIG_HOME/tmux
ln -fnsv $DOTFILES_DIR/nvim $XDG_CONFIG_HOME/nvim
ln -fnsv $DOTFILES_DIR/git $XDG_CONFIG_HOME/git
ln -fnsv $DOTFILES_DIR/lazygit/config.yml $XDG_CONFIG_HOME/lazygit/config.yml

ln -fnsv $DOTFILES_DIR/.editorconfig $HOME/.editorconfig
mkdir $HOME/.vifm && \
  ln -fnsv $DOTFILES_DIR/vifmrc $HOME/.vifm
ln -fnsv $DOTFILES_DIR/.wezterm.lua $HOME/.wezterm.lua
ln -fnsv $DOTFILES_DIR/yazi $XDG_CONFIG_HOME/yazi
ln -fnsv $HOME/dotfiles/claude/CLAUDE.md $XDG_CONFIG_HOME/claude

#########
# Must tools
#########

# zplug
ZPLUG_HOME=$XDG_CONFIG_HOME/.zplug && \
  git clone https://github.com/zplug/zplug $ZPLUG_HOME

# fzf
FZF_HOME=$HOME/.fzf && \
  git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_HOME && \
  $FZF_HOME/install

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
curl -fLo XDG_DATA_HOME/nvim/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim \
    --create-dirs https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim

# envchain
envchain --set --noecho openai CHATGPT_API_KEY

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

#########
# go install
#########
# utility tools
go install github.com/itchyny/mmv/cmd/mmv@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/rhysd/vim-startuptime@latest
go install github.com/x-motemen/ghq@latest
go install github.com/mattn/chatgpt@latest
go install github.com/mattn/memo@latest
go install github.com/umlx5h/gtrash@latest
# go development tools
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
go install oss.terrastruct.com/d2@latest
go install github.com/rhysd/actionlint/cmd/actionlint@latest

#########
# Rust(cargo)
#########
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install --locked bat
cargo install silicon
cargo install git-delta
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

#########
# Node.js
#########
npm i -g bash-language-server
npm install mdpdf -g
npm install -g yarn
npm install -g aws-cdk
npm install -g @marp-team/marp-cli
npm install -g editprompt

#########
# Python
#########
pip install --upgrade sqlparse

###
# asdf: https://asdf-vm.com/guide/getting-started.html
###
