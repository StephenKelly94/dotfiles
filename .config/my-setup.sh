#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

echo "Adding and updating repos"
sudo add-apt-repository ppa:aslatter/ppa -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt-get update

install_packages=(
    "zip"
    "unzip"
    "git"
    "curl"
    "alacritty"
    "neovim"
    "tmux"
    "zsh"
)

# Detect package manager
echo "Installing the must-have pre-requisites"
if [[ $(command -v apt-get) ]]; then
    echo "Detected apt-get"
    sudo apt-get install $install_packages
elif [[ $(command -v pacman) ]]; then
    sudo pacman -S $install_packages
fi

echo "Installing oh my zsh and plugins"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Already installed"
fi
ZSH_CUSTOM=${ZSH_CUSTOM:=$HOME/.oh-my-zsh/custom}
echo $ZSH_CUSTOM

sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
sudo git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting
sudo git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM}/plugins/zsh-autocomplete

chsh -s $(which zsh)

echo "Shell changed remember to reboot"
