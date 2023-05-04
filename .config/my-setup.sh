#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines


clipboard="xclip"
if [[ -n $WAYLAND_DISPLAY ]]; then
    clipboard="wl-clipboard"
fi

base_packages="zip unzip git curl neovim tmux zsh papirus-icon-theme ripgrep $clipboard"

debian_packages="$base_packages fd-find fonts-firacode"
arch_packages="$base_packages fd ttf-fira-code"
fedora_packages="$base_packages util-linux-user fd-find fira-code-fonts"

# Detect package manager
echo "Installing the must-have pre-requisites"

if [[ $(command -v apt-get) ]]; then
    echo "Detected debian"

    echo "Adding and updating repos first"
    sudo add-apt-repository universe -y > /dev/null
    sudo add-apt-repository ppa:aslatter/ppa -y > /dev/null
    sudo add-apt-repository ppa:neovim-ppa/unstable -y > /dev/null
    sudo add-apt-repository ppa:papirus/papirus -y > /dev/null
    sudo apt-get update > /dev/null

    sudo apt-get install -y $debian_packages
elif [[ $(command -v dnf) ]]; then
    echo "Detected Fedora"
    sudo dnf install -y $fedora_packages
elif [[ $(command -v pacman) ]]; then
    echo "Detected Arch"
    sudo pacman -Syu $arch_packages
fi

echo "Install kitty"
sh -c "$(curl -sL https://sw.kovidgoyal.net/kitty/installer.sh >/dev/null)"

echo "Installing NVM, remember to install node"
sh -c "$(curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh > /dev/null)"

echo "Installing oh my zsh and plugins"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo ""
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > /dev/null)"
else
    echo "Already installed"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:=$HOME/.oh-my-zsh/custom}

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || true
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting || true

git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm || true

chsh -s $(which zsh)

echo "Shell changed remember to reboot"
