#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

SHELL_CHANGED=false
clipboard="xclip"
if [[ -n $WAYLAND_DISPLAY ]]; then
    clipboard="wl-clipboard"
fi

# Remember packages: (not installed with this)
# Delta
# lazygit

base_packages="zip unzip git curl neovim tmux zsh ripgrep fzf exa alacritty $clipboard"

debian_packages="$base_packages fd-find fonts-firacode"
arch_packages="$base_packages fd ttf-fira-code"
fedora_packages="$base_packages util-linux-user fd-find fira-code-fonts"

# Detect package manager
echo "Installing the must-have pre-requisites"

if [ $(command -v apt-get) ]; then
    echo "Detected debian"

    echo "Adding and updating repos first"
    sudo add-apt-repository universe -y >/dev/null
    sudo add-apt-repository ppa:aslatter/ppa -y >/dev/null
    sudo add-apt-repository ppa:neovim-ppa/unstable -y >/dev/null
    sudo add-apt-repository ppa:papirus/papirus -y >/dev/null
    sudo apt-get update >/dev/null

    sudo apt-get install -y $debian_packages
elif [ $(command -v dnf) ]; then
    echo "Detected Fedora"
    sudo dnf install -y $fedora_packages
elif [ $(command -v pacman) ]; then
    echo "Detected Arch"
    sudo pacman -Syu $arch_packages
fi

if [ ! -d "$HOME/.local/kitty.app" ]; then
    echo "Install kitty"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
else
    echo "Kitty already installed"
fi

if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM, remember to install node"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash >/dev/null
else
    echo "NVM already installed"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh my zsh and plugins"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null
    ZSH_CUSTOM=$HOME/.config/zsh-custom
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || true
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting || true
    SHELL_CHANGED=true
else
    echo "ZSH already installed"
fi

if [ ! -f "$HOME/.tmux.conf" ]; then
    mkdir -p ~/.tmux/plugins/
    git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm || true
else
    echo "TMUX already installed"
fi

if [ "$SHELL_CHANGED" = "true" ]; then
    chsh -s $(which zsh)
    echo "Shell changed remember to reboot"
fi
