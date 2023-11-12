set -gx XDG_CONFIG_HOME /home/bujesse/.config
set -gx EDITOR nvim

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting

    fish_vi_key_bindings

    fish_add_path /home/bujesse/python_envs/global/bin
    fish_add_path /home/bujesse/go/bin
    fish_add_path /usr/local/go/bin
    fish_add_path /home/bujesse/.fzf/bin
    fish_add_path /home/bujesse/.cargo/bin
    fish_add_path /home/bujesse/dev_config/scripts
    fish_add_path ~/.local/share/nvm/

    fish_add_path /home/bujesse/python_envs/nvim/bin/
    fish_add_path ~/.local/bin

    set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

    set -xg PYTHONPATH /home/bujesse/dev/execution $PYTHONPATH

    # load pyenv automatically
    # set -gx PYENV_ROOT "$HOME/.pyenv"
    # fish_add_path "$PYENV_ROOT/bin"
    # . (pyenv init -|psub)
end
