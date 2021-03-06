# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=/usr/local/opt/python@3.8/bin:$HOME/bin:/usr/local/bin:$HOME/scripts:$PATH

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
        autojump
        virtualenv
        virtualenvwrapper
        vscode
        docker
        docker-compose
        zsh-vim-mode
    )
    setopt noincappendhistory
    setopt nosharehistory

# === ZSH-VIM-MODE ===
    VIM_MODE_VICMD_KEY='jk'
    bindkey -s 'kj' 'jk'

# === EXPORTS ===
    export ZSH="$HOME/.oh-my-zsh"
    export EDITOR='vim'
    export MYVIMRC='~/.vimrc'
    export GOOGLE_APPLICATION_CREDENTIALS='/Users/buj/.gcp/Arboretum-9f362cbc30d0.json'
    export FLASK_ENV=development

# === ALIASES ===
    alias zshrc="vim ~/.zshrc"
    alias vimrc="vim ~/.vimrc"
    alias karabiner="vim ~/.config/karabiner/karabiner.json"
    alias ohmyzsh="vim ~/.oh-my-zsh"
    alias lg="lazygit"
    alias ,.="source ~/.zshrc"

# === PYTHON ===
    alias python=python3
    alias pip=pip3
    export WORKON_HOME=~/python_envs
    export PYTHONBREAKPOINT="pdb.set_trace"

    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    if test -f "/usr/local/bin/virtualenvwrapper.sh"; then
        source /usr/local/bin/virtualenvwrapper.sh
    fi

    if command -v pyenv 1>/dev/null 2>&1; then
       eval "$(pyenv init -)"
    fi

    alias venv='workon .'

# === FZF ===
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_DEFAULT_COMMAND='fd --type f --color=never'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --hidden --no-ignore"
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
    bindkey -s '^o' 'fzf_find_edit^M'

# === SHORTCUTS ===
alias vsc='ssh -X vsc33810@login.hpc.kuleuven.be'


# === MISC ===
    # key repeat
    # defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
    # defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/buj/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/buj/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/buj/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/buj/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/buj/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/buj/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/buj/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/buj/google-cloud-sdk/completion.zsh.inc'; fi
