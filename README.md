# How to setup dev_config

1. Install Dependencies:

   - Terminal emulator
     - windows terminal
     - iterm2
   - [Kanagawa theme](https://github.com/rebelot/kanagawa.nvim) - check out extras/ for themes for terminal
   - nerd font (operator mono)

1. Shell:

- Install [fish](https://fishshell.com/)
  - Make default shell
    - `grep "fish" /etc/shells`
    - `chsh -s ${which fish}`
  - [fisher](https://github.com/jorgebucaran/fisher) fish package manager
    - `fisher update` (installs from .config/fish/fish_plugins)
- Install [tmux](https://github.com/tmux/tmux/wiki)
  - [tmuxp for session management](https://github.com/tmux-python/tmuxp)
  - set up tmux plugins ([tpm](https://github.com/tmux-plugins/tpm))
    - `mkdir -p ~/.tmux/plugins`
    - `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- Language dependencies:
  - [python](https://www.python.org/downloads/)
    - create nvim virtualenv: `python3 -m venv ~/python_envs/nvim`
    - activate and install requirements `source ~/python_envs/nvim/bin/activate.fish && pip install -r .config/nvim/requirements.txt`
  - [node via nvm](https://github.com/nvm-sh/nvm)
    - `nvm install latest`
    - `npm i -g neovim`
  - [Rust](https://www.rust-lang.org/tools/install)
    - Rust tools
      - [fd-find](https://github.com/sharkdp/fd) better `find`
        - symlink the binary which is called something else `ln -s $(which fdfind) ~/.local/bin/fd`
      - [ripgrep](https://github.com/BurntSushi/ripgrep) better `grep`
      - [bat](https://github.com/sharkdp/bat) better `cat`
      - [exa](https://github.com/ogham/exa) better `ls`
      - [zoxide](https://github.com/ajeetdsouza/zoxide) better `cd`
      - [rip](https://github.com/nivekuil/rip) better `rm`
      - [watchexec](https://github.com/watchexec/watchexec) - Executes commands in response to file modifications
        - `cargo install watchexec-cli`
      - [gitui](https://github.com/extrawurst/gitui) - Blazing terminal-ui for git written in rust
      - [procs](https://github.com/dalance/procs) - A modern replacement for ps written in Rust
      - [bottom](https://github.com/ClementTsang/bottom) - Yet another cross-platform graphical process/system monitor.
      - [bandwhich](https://github.com/imsnif/bandwhich) - Terminal bandwidth utilization tool
      - [dust](https://github.com/bootandy/dust) - A more intuitive version of du
      - [grex](https://github.com/pemistahl/grex) - A command-line tool and Rust library for generating regular expressions from user-provided test cases
      - [git-cliff](https://github.com/orhun/git-cliff) - A highly customizable Changelog Generator that follows Conventional Commit specifications ⛰️
      - [just](https://github.com/casey/just) - Just a command runner
      - [gitoxide](https://github.com/Byron/gitoxide) - An idiomatic, lean, fast & safe pure Rust implementation of Git
- Other shell tools
  - [fzf](https://github.com/junegunn/fzf) fuzzy finder for shell and integrates with other tools
  - [helix editor](https://docs.helix-editor.com/install.html) nice multi-cursor editing; useful inside neovim
  - [lazygit](https://github.com/jesseduffield/lazygit) TUI for git interaction

2. Desktop:

- [Obsidian](https://obsidian.md/download)
  - [Syncthing (for Obsidian)](https://syncthing.net/downloads/)
    - [SyncTrayzor (Windows system tray)](https://github.com/canton7/SyncTrayzor/releases)
      - If the latest version of syncthing is desired, just copy the .exe to `%APPDATA%/SyncTrayzor/`
