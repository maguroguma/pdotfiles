export FZF_HOME=$HOME/.fzf

# Setup fzf
# ---------
if [[ ! "$PATH" == */home/masahiro-yokoyama/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$FZF_HOME/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_HOME/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$FZF_HOME/shell/key-bindings.zsh"
