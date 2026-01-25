echo "\e[33m[zsh configuration start]\e[0m"

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# load settings
export ZSH_SUB_FILES_DIR=$ZDOTDIR/zsh.d
function loadlib() {
        lib=${1:?"You have to specify a library file"}
        if [ -f "$lib" ]; then
                . "$lib"
        fi
}

if [ -d "$XDG_CONFIG_HOME/.zplug" ]; then
    loadlib $ZSH_SUB_FILES_DIR/zshzplug
else
    echo "zplug is not installed"
fi

loadlib $ZSH_SUB_FILES_DIR/zshbasic

if [ -d "$HOME/.fzf" ]; then
    loadlib $ZSH_SUB_FILES_DIR/zshfzf
else
    echo "fzf is not installed."
fi

loadlib $ZSH_SUB_FILES_DIR/zshhooks
loadlib $ZSH_SUB_FILES_DIR/_zshexternal
loadlib $ZSH_SUB_FILES_DIR/meditation

echo "\e[33m[zsh configuration ended]\e[0m"

# シェル起動時に瞑想アートを表示（無効フラグがない場合のみ）
if [[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/meditation/disabled" ]]; then
    meditation-art.sh
fi

. "$HOME/.local/share/../bin/env"
