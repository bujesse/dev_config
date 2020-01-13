# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/jessebu/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="awesome-patched"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    git
    git-extras
    zsh-vim-mode
    common-aliases
    z
    virtualenv
    virtualenvwrapper
    vscode
    docker
)

ZSH_DISABLE_COMPFIX="true"
source $ZSH/oh-my-zsh.sh

# User configuration

# vim-mode
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/NORMAL}/(main|viins)/INSERT}"
    RPS2=$RPS1
    zle reset-prompt
}
bindkey -v
export KEYTIMEOUT=10
zle -N zle-line-init
zle -N zle-keymap-select
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins 'kj' vi-cmd-mode

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Startup commands
export WORKON_HOME=~/python_envs
source /usr/local/bin/virtualenvwrapper.sh

# Python stuff
alias python=python3
alias pip=pip3
VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python

# Aliases go here
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

function venv() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git pull origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git pull origin "${b:=$1}"
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
