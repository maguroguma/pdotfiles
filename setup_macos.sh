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
