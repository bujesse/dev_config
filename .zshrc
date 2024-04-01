# zmodload zsh/zprof
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/scripts:$HOME/.cargo/bin:$PATH

zstyle ':omz:plugins:nvm' lazy yes

# === ZSH ===
    ZSH_THEME="powerlevel10k/powerlevel10k"
    ENABLE_CORRECTION="true"
    COMPLETION_WAITING_DOTS="true"
    DISABLE_UNTRACKED_FILES_DIRTY="true"
    ZSH_DISABLE_COMPFIX="true"
    KEYTIMEOUT=1
    plugins=(
        git
        git-extras
        common-aliases
        virtualenv
        docker
        docker-compose
        colorize
        nvm

        safe-paste # Preventing any code from actually running while pasting
        vi-mode
        zsh-autosuggestions
        zsh-fzf-history-search
        zsh-history-substring-search 
    )
    setopt noincappendhistory
    setopt nosharehistory

    autoload -Uz compinit

    for dump in ~/.zcompdump(N.mh+24); do
        compinit
    done
    compinit -C

# === EXPORTS ===
    export ZSH="$HOME/.oh-my-zsh"
    export EDITOR='nvim'
    export MYVIMRC='~/.config/nvim/init.vim'
    export FLASK_ENV=development

# === PYTHON ===
    alias python=python3
    alias pip=pip3
    export WORKON_HOME=~/python_envs
    export PYTHONBREAKPOINT="pdb.set_trace"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    else
        export VIRTUALENVWRAPPER_PYTHON=/opt/rh/rh-python38/root/usr/bin/python3
    fi

    if test -f "/usr/local/bin/virtualenvwrapper.sh"; then
        source /usr/local/bin/virtualenvwrapper.sh
    fi

# === FZF ===
    FD_OPTIONS="--follow --exclude .git --exclude node_modules --exclude __pycache__"
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
    export FZF_DEFAULT_COMMAND="fd --type f $FD_OPTIONS"
    export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS --no-ignore"
    export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS --no-ignore"
    export FZF_COMPLETION_TRIGGER='**'
    # Enable fzf keybindings
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }
    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
    function fzf_find_edit() {
        local file=$(
        fzf --query="$1" --no-multi --select-1 --exit-0 \
            --preview 'bat --color=always --line-range :500 {}'
        )
        if [[ -n $file ]]; then
            $EDITOR "$file"
        fi
    }
    bindkey -s '^o' 'fzf_find_edit'
    bindkey '^j' fzf-cd-widget

# === SOURCE ===
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh

# === ALIASES ===
    # These have to be set after sourcing oh-my-zsh.sh to override plugins
    alias zshrc="nvim ~/.zshrc"
    alias nvimrc="nvim ~/.config/nvim/init.vim"
    alias vimrc="nvim ~/.vimrc"
    alias ohmyzsh="cd ~/.oh-my-zsh"
    alias ,.="source ~/.zshrc"
    alias c="clear"
    alias n="nvim"
    alias tmux="tmux -2"
    alias lg="lazygit"
    alias bat="/usr/bin/batcat"
    if [[ "$OSTYPE" != "darwin"* ]]; then
        alias open="explorer.exe"
        alias pbcopy="clip.exe"  # Windows version of pbcopy
        alias rm="rm -I"  # only prompts when deleting >3 files
    fi

# === EXTRA BINDKEYS ===
    # get back this functionality from zsh-autosuggestions
    # Ubuntu:
    # [[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" up-line-or-history
    # [[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-history
    # CentOS:
    bindkey "${terminfo[kcuu1]}" up-line-or-history
    bindkey "${terminfo[kcud1]}" down-line-or-history


    # control+right right
    bindkey "^[[1;5C" forward-word

    # Exa bindings
        # general use
        alias ls='exa'                                               # ls
        alias l='exa -lbF'                                     # list, size, type, git
        alias lt='exa -lbF --tree --level=2'                   # all list
        alias ll='exa -lbGF'                                   # long list
        alias la='exa -lbhgma --accessed --modified --created --color-scale'                   # all list
        alias lat='exa -lbhgma --color-scale --tree --level=2' # all list
        alias lx='exa -lbhgma@ --color-scale'                  # all + extended list
        alias lS='exa -1'                                            # one column, just names

# Remove highlighting on wsl2
export LS_COLORS=$LS_COLORS:'ow=1;34:';

# GO
export GOPATH=~/go/
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

eval "$(zoxide init zsh)"
# zprof
