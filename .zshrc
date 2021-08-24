# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/scripts:/mnt/c/Windows:$PATH

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
        autojump
        virtualenv
        virtualenvwrapper
        docker
        docker-compose

        safe-paste # Preventing any code from actually running while pasting

        alias-tips
        zsh-vim-mode

        zsh-autosuggestions
    )
    setopt noincappendhistory
    setopt nosharehistory

    [[ -s /mnt/c/Users/Jesse/.autojump/etc/profile.d/autojump.sh ]] && source /mnt/c/Users/Jesse/.autojump/etc/profile.d/autojump.sh
    autoload -U compinit && compinit -i

# === PLUGIN CONFIG ===
    # VIM_MODE_VICMD_KEY='jk'
    # bindkey -s 'kj' 'jk'

# === EXPORTS ===
    export ZSH="$HOME/.oh-my-zsh"
    export EDITOR='vim'
    export MYVIMRC='~/.vimrc'
    export FLASK_ENV=development

# === ALIASES ===
    alias zshrc="vim ~/.zshrc"
    alias vimrc="vim ~/.vimrc"
    alias ohmyzsh="cd ~/.oh-my-zsh"
    alias ,.="source ~/.zshrc"
    alias open="explorer.exe"
    alias c="clear"

# === PYTHON ===
    alias python=python3
    alias pip=pip3
    export WORKON_HOME=~/python_envs
    export PYTHONBREAKPOINT="pdb.set_trace"

    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    if test -f "/usr/local/bin/virtualenvwrapper.sh"; then
        source /usr/local/bin/virtualenvwrapper.sh
    fi

    if command -v pyenv 1>/dev/null 2>&1; then
       eval "$(pyenv init -)"
    fi

    alias venv='workon .'

# === FZF ===
    FD_OPTIONS="--follow --exclude .git --exclude node_modules --exclude __pycache__"
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-p:toggle-preview'"
    export FZF_DEFAULT_COMMAND="fd --type f $FD_OPTIONS"
    export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS --no-ignore"
    export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS --no-ignore"
    export FZF_COMPLETION_TRIGGER='**'
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
    bindkey -s '^o' 'fzf_find_edit^M'
    bindkey '^j' fzf-cd-widget

# === SOURCE ===
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh


# === EXTRA BINDKEYS ===
    # These have to be set after sourcing oh-my-zsh.sh to override plugins

    # get back this functionality from zsh-autosuggestions
    [[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" up-line-or-history
    [[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-history

    # control+right right
    bindkey "^[[1;5C" forward-word

    # Exa bindings
        # general use
        alias ls='exa'                                               # ls
        alias l='exa -lbF --git'                                     # list, size, type, git
        alias lt='exa -lbF --git --tree --level=2'                   # all list
        alias ll='exa -lbGF --git'                                   # long list
        alias la='exa -lbhgma --git --color-scale'                   # all list
        alias lat='exa -lbhgma --git --color-scale --tree --level=2' # all list
        alias lx='exa -lbhgma@ --git --color-scale'                  # all + extended list
        alias lS='exa -1'                                            # one column, just names

# Remove highlighting on wsl2
export LS_COLORS=$LS_COLORS:'ow=1;34:';
