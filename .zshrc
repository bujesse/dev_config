################################################################################
# ZSH CONFIG
################################################################################

# ──[ 0) PATH & BASIC ENV ]──────────────────────────────────────────────────────
export PATH="$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/scripts:$HOME/.cargo/bin:$PATH"

# ──[ 1) HISTORY: big, shared, immediate write ]────────────────────────────────
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=200000
setopt APPEND_HISTORY            # append, don’t overwrite
setopt INC_APPEND_HISTORY        # write as you execute
setopt SHARE_HISTORY             # merge across sessions
setopt HIST_IGNORE_DUPS          # skip consecutive dups
setopt HIST_IGNORE_ALL_DUPS      # drop older dups
setopt HIST_EXPIRE_DUPS_FIRST    # prune dups first
setopt HIST_VERIFY               # confirm before execute
setopt EXTENDED_HISTORY          # timestamps in history

# ──[ 2) COMPLETION: cached on Linux FS ]───────────────────────────────────────
: ${XDG_CACHE_HOME:=$HOME/.cache}
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit
compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/compcache"

# ──[ 3) PLUGINS via Antidote ]─────────────────────────────────────────────────
# Uses your manifest at $HOME/dev_config/.zsh_plugins.txt
if [[ -s "$HOME/.antidote/antidote.zsh" ]]; then
  source "$HOME/.antidote/antidote.zsh"
  antidote load "$HOME/dev_config/.zsh_plugins.txt"
fi

# ──[ 4) KEYBINDINGS: history-substring-search ]────────────────────────────────
# (plugin provides widgets; these just bind them)
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# ──[ 5) FZF: keybindings (guarded) ]───────────────────────────────────────────
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.fzf/shell/key-bindings.zsh ]] && source ~/.fzf/shell/key-bindings.zsh

# ──[ 6) ALIASES: quality-of-life ]─────────────────────────────────────────────
alias zshrc="nvim ~/.zshrc"
alias c="clear"
# dot-cd fallbacks (ensure they exist even if plugin fails)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias n="nvim"
if [[ "$OSTYPE" != "darwin"* ]]; then
  alias open="explorer.exe"
  alias pbcopy="clip.exe"
  alias rm="rm -I"
fi

# ──[ 7) EXA ALIASES ]──────────────────────────────────────────────────────────
alias ls='exa'                                               # ls
alias l='exa -lbF'                                           # list, size, type, git
alias lt='exa -lbF --tree --level=2'                         # tree
alias ll='exa -lbGF'                                         # long list
alias la='exa -lbhgma --accessed --modified --created --color-scale'
alias lat='exa -lbhgma --color-scale --tree --level=2'
alias lx='exa -lbhgma@ --color-scale'                        # extended attrs
alias lS='exa -1'                                            # names only

# ──[ 8) WSL TWEAKS ]───────────────────────────────────────────────────────────
export LS_COLORS=$LS_COLORS:'ow=1;34:'

# ──[ 9) LANG TOOLCHAINS ]──────────────────────────────────────────────────────
# Go
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Pyenv (guarded)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"
command -v pyenv >/dev/null && eval "$(pyenv virtualenv-init -)"
export PYENV_VERSION="3.12"

# ──[ 10) UTILITIES ]───────────────────────────────────────────────────────────
# zoxide (guarded)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# NVM: true lazy-load (keep OMZ nvm plugin disabled)
export NVM_DIR="$HOME/.nvm"
export NVM_AUTO_USE=0
_nvm_lazy_load(){ unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; }
nvm(){  _nvm_lazy_load; nvm "$@"; }
node(){ _nvm_lazy_load; command node "$@"; }
npm(){  _nvm_lazy_load; command npm "$@"; }
npx(){  _nvm_lazy_load; command npx "$@"; }

# ──[ 11) PROMPT / THEME ]──────────────────────────────────────────────────────
# If using powerlevel10k, uncomment next line (Antidote loads p10k theme repo).
# [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh || PROMPT='%n@%m:%~ %# '
# If using Pure via Antidote, no extra sourcing needed.

# ──[ 12) PROFILING (off by default) ]──────────────────────────────────────────
# zmodload zsh/zprof
# zprof

