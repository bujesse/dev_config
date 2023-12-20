#!/bin/bash

# Function for user confirmation
confirm() {
	read -r -p "$1 [y/N]: " response
	if [[ ! "$response" =~ ^[Yy]$ ]]; then
		return 1
	fi
	return 0
}

function get_user_version() {
	read -r -p "$1 (default is $2): " version
	version=${version:-$2}
	echo "$version"
}

echo "Update system and install inotify-tools"
sudo yum update
sudo yum install inotify-tools

echo "Create and populate .clipboard file"
echo "foo" >.clipboard

echo "Install Latest CMake"
cd /usr/local/src
echo "Find the latest version of CMake at https://cmake.org/download/ (use the Linux x86_64 tar.gz link)"
cmake_version=$(get_user_version "Enter CMake version" "3.22.2")
cmake_url="https://github.com/Kitware/CMake/releases/download/v$cmake_version/cmake-$cmake_version-linux-x86_64.tar.gz"
echo "Downloading cmake from: $cmake_url"
curl -LO "$cmake_url"
tar -xvf "cmake-$cmake_version-linux-x86_64.tar.gz"
mv "cmake-$cmake_url" /usr/local/cmake
echo 'export PATH="/usr/local/cmake/bin:$PATH"' >>~/.bash_profile
. ~/.bash_profile

echo "Clone dev_config repository"
git clone https://github.com/bujesse/dev_config.git
cd dev_config
git checkout centos7

if confirm "Install Fish shell?"; then
	cd /etc/yum.repos.d/
	sudo wget https://download.opensuse.org/repositories/shells:fish:release:3/CentOS_7/shells:fish:release:3.repo
	sudo yum install -y fish
	curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
	fisher update
	fisher install IlanCosman/tide@v6
else
	echo "Skipping Fish shell installation."
fi

echo "Install fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
fisher install PatrickF1/fzf.fish

echo "Install nvm"
echo "Find the latest version of nvm at (https://github.com/nvm-sh/nvm#install--update-script)"
nvm_version=$(get_user_version "Enter nvm version" "0.39.7")
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$nvm_version/install.sh" | bash
fisher install jorgebucaran/nvm.fish
nvm install v17

echo "Set up Python virtual environment"
python3 -m venv ~/python_envs/nvim
source ~/python_envs/nvim/bin/activate.fish && pip install -r .config/nvim/requirements.txt

echo "Install Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source
cargo install fd-find ripgrep bat exa rm-improved stylua git-delta bottom blackd-client just

echo "Install Go"
curl -LO https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
go install github.com/jesseduffield/lazygit@latest
fish_add_path ~/go/bin

echo "Install clang for treesitter compile"
sudo yum install -y centos-release-scl
sudo yum install -y llvm-toolset-7
scl enable llvm-toolset-7 fish

echo "Install tmux"
sudo yum install -y libevent-devel bison
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make && sudo make install
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Install additional packages and configurations"
pip uninstall typing
pip install debugpy
git clone https://partnerscap@dev.azure.com/partnerscap/Partners Capital/_git/execution
ln -s ~/execution/venv/ venv
ln -s /projects/execution-ui-static/node_modules node_modules

echo "Set up SSH keys"
ssh-keygen -t ed25519 -C "bu.jesse@gmail.com"
cat ~/.ssh/id_ed25519.pub
echo "Add the above SSH key to https://github.com/settings/keys"

echo "Install lnav"
sudo yum install -y lnav

echo "Install FUSE for NVIM"
sudo yum install -y fuse-sshfs
set user "$(whoami)"
usermod -a -G fuse "$user"

echo "Set up alias for NVIM"
echo "alias -s n ~/dev_config/bin/nvim.appimage" >>~/.bashrc

echo "Display message for manual configuration steps"
echo "Please manually install treesitter by looking at which ones are failing and using :TSInstall bash vim tsx html javascript typescript markdown in Neovim."

echo "Display message for inotify watch limit"
echo "Temporarily increase inotify watch limit: sudo sysctl fs.inotify.max_user_watches=524288"
echo "Permanently increase inotify watch limit: sudo sh -c 'echo \"fs.inotify.max_user_watches=524288\" >> /etc/sysctl.conf'"
