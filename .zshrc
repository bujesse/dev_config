################################################################################
# ZSH CONFIG
################################################################################

# ──[ 0) PATH & BASIC ENV ]──────────────────────────────────────────────────────
typeset -U path PATH
path=(
  $HOME/bin
  $HOME/.local/bin
  $HOME/scripts
  $HOME/.cargo/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  $path
)

if [[ -o interactive ]]; then
  path=(${path:#/mnt/c/*})
fi

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

# Fix Ctrl+Arrow keys for word navigation
bindkey '^[[1;5D' backward-word   # Ctrl+Left
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5A' beginning-of-line
bindkey '^[[1;5B' end-of-line

# ──[ 5) FZF: keybindings (guarded) ]───────────────────────────────────────────
# [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
# [[ -f ~/.fzf/shell/key-bindings.zsh ]] && source ~/.fzf/shell/key-bindings.zsh

# ──[ 6) ALIASES: quality-of-life ]─────────────────────────────────────────────
alias zshrc="nvim ~/.zshrc"
alias c="clear"
# dot-cd fallbacks (ensure they exist even if plugin fails)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias lg='lazygit'
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
path=(
  /usr/local/go/bin
  $GOPATH/bin
  $path
)

# Pyenv (guarded)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" $path)
command -v pyenv >/dev/null && eval "$(pyenv init -)"
command -v pyenv >/dev/null && eval "$(pyenv virtualenv-init -)"
export PYENV_VERSION="3.12"

# ──[ 10) UTILITIES ]───────────────────────────────────────────────────────────
# zoxide (guarded)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# fnm
if command -v fnm >/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ──[ 11) PROMPT / THEME ]──────────────────────────────────────────────────────
# If using Pure via Antidote, no extra sourcing needed.

# ──[ 12) PROFILING (off by default) ]──────────────────────────────────────────
# zmodload zsh/zprof
# zprof


# Added by flyctl installer
export FLYCTL_INSTALL="/home/bujesse/.fly"
[[ -d "$FLYCTL_INSTALL/bin" ]] && path=("$FLYCTL_INSTALL/bin" $path)

path=(${(u)path})
export PATH
