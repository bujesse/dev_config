#!/bin/bash

DIR=${PWD##*/}
if [ DIR != "dev_config" ]; then
    printf "Run from within dev_config/\n"
    exit 1
fi

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi
brew install vim fzf fd ripgrep pyenv node

pyenv install 3.9.1
pyenv global 3.9.1

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

source $HOME/.zshrc

# Install required python stuff
python -m pip install -U pip
pip install --user virtualenv virtualenvwrapper python-language-server[autopep8]

# Remove original repo
cd ..
rm -rf dev_config

