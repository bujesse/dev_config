#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo_info() { printf "${YELLOW}$1${NC}\n"; }
echo_success() { printf "${GREEN}$1${NC}\n"; }
echo_error() { printf "${RED}$1${NC}\n"; }
echo_header() { printf "${BLUE}${1}${NC}\n"; }

prompt_action() {
    local action=$1
    while true; do
        read -p "$action? [y/n] " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN"
esac

ARCH=$(uname -m)
echo_info "Detected OS: ${MACHINE}"
echo_info "Detected architecture: ${ARCH}"
echo ""

# Homebrew (macOS only)
if [[ "$MACHINE" == "Mac" ]]; then
    echo_header "=== Homebrew ==="
    if ! command -v brew &> /dev/null; then
        echo_info "Status: Not installed"
        if prompt_action "Install Homebrew"; then
            echo_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            if [[ "$ARCH" == "arm64" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            echo_success "Homebrew installed"
        fi
    else
        echo_success "Status: Installed"
        BREW_VERSION=$(brew --version | head -n1)
        echo_info "Version: ${BREW_VERSION}"
        
        if prompt_action "Update Homebrew"; then
            brew update
            echo_success "Homebrew updated"
        fi
    fi
    echo ""
elif [[ "$MACHINE" == "Linux" ]]; then
    echo_info "Updating package lists..."
    sudo apt-get update -qq
fi

# Python (uv)
echo_header "=== Python (via uv) ==="
if ! command -v uv &> /dev/null; then
    echo_info "Status: Not installed"
    if prompt_action "Install uv (Python version manager)"; then
        echo_info "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
        [[ -f "$HOME/.cargo/env" ]] && source $HOME/.cargo/env
        echo_success "uv installed"
        
        echo_info "Fetching available Python versions..."
        LATEST_PYTHON=$(uv python list --only-installed 2>/dev/null | head -n1 || echo "none")
        if [[ "$LATEST_PYTHON" == "none" ]]; then
            echo_info "No Python versions installed"
            if prompt_action "Install latest Python"; then
                uv python install
                echo_success "Python installed"
            fi
        fi
    fi
else
    echo_success "Status: Installed"
    UV_VERSION=$(uv --version)
    echo_info "uv version: ${UV_VERSION}"
    
    if prompt_action "Update uv"; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        echo_success "uv updated"
    fi
    
    echo_info "Installed Python versions:"
    uv python list --only-installed
    
    if prompt_action "Install/update to latest Python"; then
        uv python install
        echo_success "Python updated"
    fi
fi
echo ""

# Node (fnm)
echo_header "=== Node.js (via fnm) ==="
if ! command -v fnm &> /dev/null; then
    echo_info "Status: Not installed"
    if prompt_action "Install fnm (Node version manager)"; then
        echo_info "Installing fnm..."
        curl -fsSL https://fnm.vercel.app/install | bash
        
        if [[ "$MACHINE" == "Mac" ]]; then
            export PATH="$HOME/.local/share/fnm:$PATH"
        else
            export PATH="$HOME/.fnm:$PATH"
        fi
        eval "$(fnm env --use-on-cd)" 2>/dev/null || true
        
        echo_success "fnm installed"
        
        if prompt_action "Install latest Node LTS"; then
            fnm install --lts
            fnm use lts-latest
            fnm default lts-latest
            echo_success "Node LTS installed"
        fi
    fi
else
    echo_success "Status: Installed"
    FNM_VERSION=$(fnm --version)
    echo_info "fnm version: ${FNM_VERSION}"
    
    if command -v node &> /dev/null; then
        CURRENT_NODE=$(node --version)
        echo_info "Current Node: ${CURRENT_NODE}"
    else
        echo_info "No Node version currently active"
    fi
    
    if prompt_action "Update fnm"; then
        curl -fsSL https://fnm.vercel.app/install | bash --skip-shell
        echo_success "fnm updated"
    fi
    
    echo_info "Checking for latest Node LTS..."
    if prompt_action "Install/update to latest Node LTS"; then
        fnm install --lts
        fnm use lts-latest
        fnm default lts-latest
        NEW_NODE=$(node --version)
        echo_success "Node updated to ${NEW_NODE}"
    fi
fi
echo ""

# Rust
echo_header "=== Rust (via rustup) ==="
if ! command -v rustup &> /dev/null; then
    echo_info "Status: Not installed"
    if prompt_action "Install Rust"; then
        echo_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
        echo_success "Rust installed"
    fi
else
    echo_success "Status: Installed"
    RUSTC_VERSION=$(rustc --version)
    echo_info "Current: ${RUSTC_VERSION}"
    
    echo_info "Checking for updates..."
    RUSTUP_CHECK=$(rustup check 2>&1)
    echo "$RUSTUP_CHECK"
    
    if echo "$RUSTUP_CHECK" | grep -q "Update available"; then
        if prompt_action "Update Rust"; then
            rustup update
            NEW_VERSION=$(rustc --version)
            echo_success "Rust updated to ${NEW_VERSION}"
        fi
    else
        echo_success "Already on latest version"
    fi
fi
echo ""

# Go
echo_header "=== Go ==="
if ! command -v go &> /dev/null; then
    echo_info "Status: Not installed"
    if prompt_action "Install Go"; then
        if [[ "$MACHINE" == "Mac" ]]; then
            if command -v brew &> /dev/null; then
                echo_info "Installing Go via Homebrew..."
                brew install go
                echo_success "Go installed"
            else
                echo_error "Homebrew not found. Install Homebrew first."
            fi
        else
            echo_info "Fetching latest Go version..."
            GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n1)
            echo_info "Latest version: ${GO_VERSION}"
            
            echo_info "Installing Go..."
            wget -q https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf /tmp/go.tar.gz
            rm /tmp/go.tar.gz
            echo_success "Go installed"
        fi
    fi
else
    echo_success "Status: Installed"
    CURRENT_GO_VERSION=$(go version | awk '{print $3}')
    echo_info "Current: ${CURRENT_GO_VERSION}"
    
    if [[ "$MACHINE" == "Mac" ]]; then
        if command -v brew &> /dev/null; then
            echo_info "Checking for updates via Homebrew..."
            BREW_OUTDATED=$(brew outdated go)
            if [[ -n "$BREW_OUTDATED" ]]; then
                echo_info "Update available: ${BREW_OUTDATED}"
                if prompt_action "Update Go"; then
                    brew upgrade go
                    NEW_VERSION=$(go version | awk '{print $3}')
                    echo_success "Go updated to ${NEW_VERSION}"
                fi
            else
                echo_success "Already on latest version"
            fi
        fi
    else
        echo_info "Checking for latest version..."
        LATEST_GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n1)
        echo_info "Latest: ${LATEST_GO_VERSION}"
        
        if [[ "$CURRENT_GO_VERSION" == "$LATEST_GO_VERSION" ]]; then
            echo_success "Already on latest version"
        else
            echo_info "Update available: ${CURRENT_GO_VERSION} → ${LATEST_GO_VERSION}"
            if prompt_action "Update Go"; then
                echo_info "Downloading ${LATEST_GO_VERSION}..."
                wget -q https://go.dev/dl/${LATEST_GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz
                sudo rm -rf /usr/local/go
                sudo tar -C /usr/local -xzf /tmp/go.tar.gz
                rm /tmp/go.tar.gz
                echo_success "Go updated to ${LATEST_GO_VERSION}"
            fi
        fi
    fi
fi
echo ""

# Summary
echo_success "=== Summary ==="
echo ""

if command -v uv &> /dev/null; then
    echo_header "Python (via uv):"
    uv python list --only-installed 2>/dev/null || echo "No versions installed"
    echo ""
fi

if command -v node &> /dev/null; then
    echo_header "Node (via fnm):"
    echo "Node: $(node --version)"
    echo "npm: $(npm --version)"
    echo ""
fi

if command -v rustc &> /dev/null; then
    echo_header "Rust:"
    rustc --version
    cargo --version
    echo ""
fi

if command -v go &> /dev/null; then
    echo_header "Go:"
    go version
    echo ""
fi

# Shell configuration
if [[ "$MACHINE" == "Mac" ]]; then
    SHELL_RC="~/.zshrc"
else
    SHELL_RC="~/.bashrc"
fi

echo_success "=== Shell Configuration ==="
echo_info "Ensure these lines are in your ${SHELL_RC}:"
cat << 'EOF'

# uv (Python)
export PATH="$HOME/.local/bin:$PATH"

# fnm (Node)
export PATH="$HOME/.local/share/fnm:$PATH"  # macOS
export PATH="$HOME/.fnm:$PATH"              # Linux
eval "$(fnm env --use-on-cd)"

# Rust
source "$HOME/.cargo/env"

# Go
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
EOF

echo ""
echo_info "Run: source ${SHELL_RC} (or restart terminal)"
