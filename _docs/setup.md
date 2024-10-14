# セットアップ手順

git, curlなどはプリインストール前提だけど、入ってなかったら適宜インストールする。

## zshのインストール

5.8.1以上なら問題なさそう。

インストールしたらデフォルトのシェルをzshに変更する。

```sh
chsh -s /bin/zsh
```

## PlemolJPのインストール

各種OSに合わせてインストールする。

## 各種設定ファイルのシンボリックリンクを作成する

```sh
git clone https://github.com/maguroguma/dotfiles ~/dotfiles

DOTFILES_DIR=$HOME/dotfiles
XDG_CONFIG_HOME=$HOME/.config
XDG_DATA_HOME="$HOME/.local/share"

ln -fnsv $DOTFILES_DIR/.zshenv $HOME/.zshenv
ln -fnsv $DOTFILES_DIR/zsh $XDG_CONFIG_HOME/zsh
ln -fnsv $DOTFILES_DIR/tmux $XDG_CONFIG_HOME/tmux
ln -fnsv $DOTFILES_DIR/nvim $XDG_CONFIG_HOME/nvim
ln -fnsv $DOTFILES_DIR/git $XDG_CONFIG_HOME/git

ln -fnsv $DOTFILES_DIR/.editorconfig $HOME/.editorconfig
mkdir $HOME/.vifm && ln -fnsv $DOTFILES_DIR/vifmrc $HOME/.vifm
ln -fnsv $DOTFILES_DIR/.wezterm.lua $HOME/.wezterm.lua
```

## weztermのインストール

OS共通のターミナルとして。

## tmuxのインストール

3.2a以降をインストールする。
基本的にはパッケージマネージャで問題なさそう。

## zplugのインストール

```sh
ZPLUG_HOME=$XDG_CONFIG_HOME/.zplug && \
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
```

## fzfのインストール

```sh
FZF_HOME=$HOME/.fzf && \
  git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_HOME && \
  $FZF_HOME/install
```

## Goのインストール、およびGo製ツールのインストール

Goはenv系やasdfでインストールせずに、その時の最新版をインストールする。

```sh
go install github.com/itchyny/mmv/cmd/mmv@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/rhysd/vim-startuptime@latest
go install github.com/x-motemen/ghq@latest
go install github.com/mattn/chatgpt@latest
go install github.com/mattn/memo@latest
go install oss.terrastruct.com/d2@latest
```

## vifmのインストール

パッケージマネージャでインストールする。

## neovimのインストール

v0.8.2からv0.9.0までを選びたい。

## asdfとnodeのインストール

asdfのインストール手順はOSに合わせて変える。
インストール後はnodeのstableをインストールする。

```sh
asdf install nodejs {{ stable-version }} && \
  asdf global nodejs {{ stable-version }}
```

## denoのインストール

```sh
curl -fsSL https://deno.land/x/install/install.sh | sh
```

## transのインストール

```sh
mkdir $HOME/mybin
wget -O $HOME/mybin/trans git.io/trans
chmod +x $HOME/mybin/trans
```

## git-secretsのインストール

```sh
git clone git@github.com:awslabs/git-secrets.git $GOPATH/src/github.com/awslabs/git-secrets
cd $GOPATH/src/github.com/awslabs/git-secrets
sudo make install
cd --
```

## envchainのインストール

macOSの場合は考えることはないが、Linuxだとディストリビューションごとに変える必要がありそう。
現時点ではOpenAIのAPIキーのみ登録しておく。

```sh
envchain --set --noecho openai CHATGPT_API_KEY
```

## Rustのインストール

以下のコマンドでインストールできるが、インストール後は再起動が必要。

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## zoxideのインストール

```sh
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

## Dockerのインストール

公式のOSごとのドキュメントに従う。

---

その他のほぼ必須なツール。

- ripgrep
- direnv
- wget
- gnu-sed
- gawk
- git-delta
- nkf
- envchain
- asdf
  - 少なくともnodeはasdfで管理する

準必須ツール。
必要になったタイミングでインストールする。

- bat
- silicon
- tldr
- gibo
