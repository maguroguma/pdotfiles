function loadlib() {
        lib=${1:?"You have to specify a library file"}
        if [ -f "$lib" ]; then
                . "$lib"
        fi
}
export ZSH_SUB_FILES_DIR=$HOME/.zsh.d

# load files
loadlib $ZSH_SUB_FILES_DIR/zshzplug
loadlib $ZSH_SUB_FILES_DIR/zshbasic
loadlib $ZSH_SUB_FILES_DIR/zshfzf
loadlib $ZSH_SUB_FILES_DIR/_zshexternal

# direnv
eval "$(direnv hook zsh)"

# zoxide
eval "$(zoxide init zsh)"

######################################################################

. /opt/homebrew/opt/asdf/libexec/asdf.sh
