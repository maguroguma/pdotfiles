# M1 macの場合はhomebrewのPATH設定がIntel macと微妙に異なるので注意が必要

#########
# homebrew
#########
brew install ripgrep
brew install tldr
brew install bat
brew install direnv
brew install gibo
brew install ghq
brew install wget
brew install gnu-sed
brew install gawk
brew install git-delta
brew install mecab
brew install mecab-ipadic
brew install nkf
brew install pwgen
brew install golangci-lint
brew upgrade golangci-lint
brew install yq
brew install tree
brew install sqlparse
brew install envchain
brew install coreutils findutils gnu-sed grep
brew install curl

brew tap homebrew/cask-fonts
brew install font-plemol-jp
brew install font-plemol-jp-nf
brew install font-plemol-jp-nfj
brew install font-plemol-jp-hs

#########
# others
#########
mkdir $HOME/Pictures/screenshots
defaults write com.apple.screencapture location $HOME/Pictures/screenshots

# docker completion
mkdir -p ~/.zsh/completion
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion ~/.zsh/completion/_docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion ~/.zsh/completion/_docker-compose

# asdf
brew install asdf
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
# node(asdf)
asdf install nodejs latest
asdf global nodejs latest
