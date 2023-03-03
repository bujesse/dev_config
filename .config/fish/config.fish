if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx EDITOR /home/vagrant/dev/nvim-linux64/bin/nvim
    set -g fish_greeting

    fish_vi_key_bindings

    fish_add_path /home/vagrant/python_envs/global/bin
    fish_add_path /home/vagrant/go/bin
    fish_add_path /usr/local/go/bin
    fish_add_path ~/.local/share/nvm/v17.9.1/bin
    fish_add_path /home/vagrant/.fzf/bin
    fish_add_path /home/vagrant/.cargo/bin
    fish_add_path /home/vagrant/dev_config/scripts

    fish_add_path /home/vagrant/python_envs/nvim/bin/
    fish_add_path ~/.local/bin

    set fzf_dir_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

    # load pyenv automatically
    # set -gx PYENV_ROOT "$HOME/.pyenv"
    # fish_add_path "$PYENV_ROOT/bin"
    # . (pyenv init -|psub)
end
