#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

install_packages="zip unzip git curl alacritty neovim tmux zsh papirus-icon-theme ripgrep fd xclip"

# Detect package manager
if [[ $(command -v apt-get) ]]; then
    echo "Detected apt-get"
    echo "Adding and updating repos"
    sudo add-apt-repository ppa:aslatter/ppa -y
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo add-apt-repository ppa:papirus/papirus -y
    sudo apt-get update

    echo "Installing the must-have pre-requisites"
    sudo apt-get install -y $install_packages
elif [[ $(command -v pacman) ]]; then
    echo "Installing the must-have pre-requisites"
    sudo pacman -Syu $install_packages
fi

echo "Installing NVM, remember to install node"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing oh my zsh and plugins"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Already installed"
fi
ZSH_CUSTOM=${ZSH_CUSTOM:=$HOME/.oh-my-zsh/custom}

sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || true
sudo git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting || true

sudo git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm

chsh -s $(which zsh)

echo "Shell changed remember to reboot"
