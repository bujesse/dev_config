export PATH=$HOME/bin:/usr/local/bin:$PATH

# === ZSH ===
    ZSH_THEME="powerlevel10k/powerlevel10k"
    POWERLEVEL9K_MODE="awesome-patched"
    ENABLE_CORRECTION="true"
    COMPLETION_WAITING_DOTS="true"
    DISABLE_UNTRACKED_FILES_DIRTY="true"
    ZSH_DISABLE_COMPFIX="true"
    plugins=(
        git
        git-extras
        common-aliases
        z
        virtualenv
        virtualenvwrapper
        vscode
        docker
    )

# === EXPORTS ===
    export ZSH="$HOME/.oh-my-zsh"
    export EDITOR='vim'
    export MYVIMRC='~/.vimrc'

# === ALIASES ===
    alias zshrc="vim ~/.zshrc"
    alias vimrc="vim ~/.vimrc"
    alias ohmyzsh="vim ~/.oh-my-zsh"

# === PYTHON ===
    alias python=python3
    alias pip=pip3
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    export WORKON_HOME=~/python_envs
    export PYTHONBREAKPOINT="pdb.set_trace"
    source /usr/local/bin/virtualenvwrapper.sh
    function venv() {
        if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
            git pull origin "${*}"
        else
            [[ "$#" == 0 ]] && local b="$(git_current_branch)"
            git pull origin "${b:=$1}"
        fi
    }

# === FZF ===
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    [ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_DEFAULT_COMMAND='fd --type f --color=never'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d . --color=never'
    function fzf_find_edit() {
        local file=$(
        fzf --query="$1" --no-multi --select-1 --exit-0 \
            --preview 'bat --color=always --line-range :500 {}'
        )
        if [[ -n $file ]]; then
            $EDITOR "$file"
        fi
    }
    alias ffe='fzf_find_edit'

# === MISC ===
    # key repeat
    # defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
    # defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
source $ZSH/oh-my-zsh.sh

