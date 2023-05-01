#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines


clipboard="xclip"
if [[ -n $WAYLAND_DISPLAY ]]; then
    clipboard="wl-clipboard"
fi

base_packages="zip unzip git curl kitty neovim tmux zsh papirus-icon-theme ripgrep fd $clipboard"

debian_packages="$base_packages fonts_firacode"
arch_packages="$base_packages ttf-fira-code"
fedora_packages="$base_packages fira-code-fonts"

# Detect package manager
echo "Installing the must-have pre-requisites"

if [[ $(command -v apt-get) ]]; then
    echo "Detected debian"

    echo "Adding and updating repos first"
    sudo add-apt-repository universe
    sudo add-apt-repository ppa:aslatter/ppa -y
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo add-apt-repository ppa:papirus/papirus -y
    sudo apt-get update

    sudo apt-get install -y $debian_packages
elif [[ $(command -v dnf) ]]; then
    echo "Detected Fedora"
    sudo dnf install $fedora_packages
elif [[ $(command -v pacman) ]]; then
    echo "Detected Arch"
    sudo pacman -Syu $arch_packages
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

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || true
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting || true

git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm

chsh -s $(which zsh)

echo "Shell changed remember to reboot"
