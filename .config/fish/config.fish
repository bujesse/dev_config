if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx EDITOR nvim
    set -g fish_greeting

    fish_vi_key_bindings

    fish_add_path /home/vagrant/python_envs/global/bin 
    fish_add_path /home/vagrant/go/bin 
    fish_add_path /usr/local/go/bin 
    fish_add_path ~/.local/share/nvm/v17.9.1/bin
    fish_add_path /home/vagrant/.fzf/bin 
    fish_add_path /home/vagrant/.cargo/bin

    set fzf_dir_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
end