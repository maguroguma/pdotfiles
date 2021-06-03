# 設定ファイルとキーバインディング

```shell
# VSCodeの設定ファイル
# ~/Library/Application\ Support/Code/User/settings.json
# ~/Library/Application\ Support/Code/User/keybindings.json

cd $HOME/Library/Application\ Support/Code/User
rm settings.json
ln -fnsv $HOME/dotfiles/vscode/settings.json ./settings.json
rm keybindings.json
ln -fnsv $HOME/dotfiles/vscode/keybindings.json ./keybindings.json
```

# 拡張機能

```shell
# codeのインストール
# VSCode上で shift+command+p => shell command: install 'code' command in PATH command.

code --list-extensions > extensions

cat ./extensions | while read line
do
  code --install-extension $line
done
```
