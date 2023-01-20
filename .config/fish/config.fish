if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx EDITOR hx

    fish_add_path /home/vagrant/python_envs/global/bin 
    fish_add_path /home/vagrant/go/bin 
    fish_add_path /usr/local/go/bin 
    fish_add_path /home/vagrant/.fzf/bin 
    fish_add_path /home/vagrant/.cargo/bin
end
