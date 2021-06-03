export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

export TERM=xterm-color
alias ls='ls -G'
alias ll='ls -hl'

export GOPATH=$HOME/Development/Go
export PATH=$PATH:$GOPATH/bin

PS1='$\[\e[1;33m\]\u\[\e[1;34m\]:\w\n\[\e[m\]\\$'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
