# How to setup dev_config

1. Install:
    - nerd font (operator mono)
    - Install zsh, omzsh, p10k
    - Install python, pip, virtualenv, virtualenvwrapper
    - npm
    - yarn `npm i -g yarn`
    - fd-find `sudo apt install fd-find`
        - symlink the binary which is called something else `ln -s $(which fdfind) ~/.local/bin/fd`
    - ripgrep `sudo apt-get install ripgrep`
    - bat
    - python env called python_envs/nvim. `pip install -r nvim_requirements.txt`
    - rust `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
        - `cargo install stylua`
    - exa
1. Clone this repo: `git clone git@github.com:bujesse/dev_config.git`
1. Run symlink generator: `./symlink-setup.sh`

## Neovim

### Installation
- Linux/WSL2 (nightly)
    1. Download nvim.appimage: https://github.com/neovim/neovim/releases/tag/nightly

- Mac (stable)
    1. `brew install nvim`

### Setup
- Install plugins (either vim-plug or packer)
    - LspInstall \<language>
    - TSInstall \<language>
    - `:checkhealth`
