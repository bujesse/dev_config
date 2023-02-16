# How to setup dev_config

1. Install Dependencies:
    - nerd font (operator mono)
  - Shell:
    - Install [fish](https://fishshell.com/)
        - Make default shell
            - grep "fish" /etc/shells
            - chsh -s ${which fish}
        - [fisher](https://github.com/jorgebucaran/fisher) fish package manager
            - `fisher update` (installs from .config/fish/fish\_plugins)
    - Install [tmux](https://github.com/tmux/tmux/wiki)
      - [tmuxp for session management](https://github.com/tmux-python/tmuxp)
  - Language dependencies:
      - [python](https://www.python.org/downloads/)
          - create nvim virtualenv: `python3 -m venv ~/python_envs/nvim`
          - activate and install requirements `source ~/python_envs/nvim/bin/activate.fish && pip install -r .config/nvim/requirements.txt`
      - [node via nvm](https://github.com/nvm-sh/nvm)
          - `nvm install latest`
          - `npm i -g neovim`
      - [Rust](https://www.rust-lang.org/tools/install)
        - [fd-find](https://github.com/sharkdp/fd) better `find`
          - symlink the binary which is called something else `ln -s $(which fdfind) ~/.local/bin/fd`
        - [ripgrep](https://github.com/BurntSushi/ripgrep) better `grep`
        - [bat](https://github.com/sharkdp/bat) better `cat`
        - [exa](https://github.com/ogham/exa) better `ls`
        - [zoxide](https://github.com/ajeetdsouza/zoxide) better `cd`
  - Other tools
    - [fzf](https://github.com/junegunn/fzf) fuzzy finder for shell and integrates with other tools
    - [helix editor](https://docs.helix-editor.com/install.html) nice multi-cursor editing; useful inside neovim
    - [lazygit](https://github.com/jesseduffield/lazygit) TUI for git interaction

