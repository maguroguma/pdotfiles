#########
# homebrew
#########
# ag, ripgrep
brew install ripgrep
brew install ag
# tldr
brew install tldr
# peco
brew install peco
# mdpdf (npm is required)
npm install mdpdf -g
# bat (cat by Rust)
brew install bat
# direnv
brew install direnv
# duf (du by Go)
brew install duf
# git
brew install gibo
brew install ghq
git config --global ghq.root $GOPATH/src
# hub
brew install hub
# glow
brew install glow
# wget
brew install wget
# gnu-sed, gawk
brew install gnu-sed
brew install gawk
# git-delta
brew install git-delta

#########
# System fonts
#########
# font(vim)
brew tap sanemat/font
brew install ricty --with-powerline
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf
# nerd font
git clone https://github.com/macchaberrycream/RictyDiminished-Nerd-Fonts.git

#########
# mac screen shots
#########
mkdir $HOME/Pictures/screenshots
defaults write com.apple.screencapture location $HOME/Pictures/screenshots

# asdf
brew install asdf
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
# node(asdf)
asdf install nodejs latest
asdf global nodejs latest

# docker completion
mkdir -p ~/.zsh/completion
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion ~/.zsh/completion/_docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion ~/.zsh/completion/_docker-compose

# mecab
brew install mecab
brew install mecab-ipadic

# shell-gei
brew install nkf
brew install pwgen

# golangci-lint
brew install golangci-lint
brew upgrade golangci-lint

# yq(yaml parser)
brew install yq
