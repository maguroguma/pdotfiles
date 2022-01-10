######################################################################
# https://qiita.com/yu-ichiro/items/6441453321c06484bb22
# https://qiita.com/muran001/items/7b104d33f5ea3f75353f

function loadlib() {
        lib=${1:?"You have to specify a library file"}
        if [ -f "$lib" ];then #ファイルの存在を確認
                . "$lib"
        fi
}

export ZSH_SUB_FILES_DIR=$HOME/.zsh.d

loadlib $ZSH_SUB_FILES_DIR/zshexport
loadlib $ZSH_SUB_FILES_DIR/zshalias
loadlib $ZSH_SUB_FILES_DIR/zshbasic
loadlib $ZSH_SUB_FILES_DIR/zshzplug
loadlib $ZSH_SUB_FILES_DIR/zshfzf
loadlib $ZSH_SUB_FILES_DIR/zshfzfgit
loadlib $ZSH_SUB_FILES_DIR/zshpeco
# loadlib $ZSH_SUB_FILES_DIR/zshnavi

# for direnv
eval "$(direnv hook zsh)"

######################################################################

# @os-dependency
# Haskell
source /Users/yokoyamamasahiro/.ghcup/env
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

# @os-dependency
# added by travis gem
[ -f /Users/yokoyamamasahiro/.travis/travis.sh ] && source /Users/yokoyamamasahiro/.travis/travis.sh
