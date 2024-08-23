#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

curl_package() {
    local url="$1"
    local args="$2"
    curl -sSL "$url" | sh /dev/stdin "$args" >/dev/null
}

install_kitty() {
    local kitty_loc="$HOME/.local/kitty.app/"
    if [ -d "$kitty_loc" ]; then
        echo "Kitty already installed"
    else
        echo "Installing kitty"
        curl_package "https://sw.kovidgoyal.net/kitty/installer.sh" "launch=n"
        sudo ln -s "$kitty_loc"/bin/kitty "$kitty_loc"/bin/kitten "$HOME"/.local/bin/
        # Place the kitty.desktop file somewhere it can be found by the OS
        cp "$kitty_loc"/share/applications/kitty.desktop ~/.local/share/applications/
        # Update the paths to the kitty and its icon in the kitty desktop file(s)
        sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
        sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty.desktop
        # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
        echo 'kitty.desktop' >~/.config/xdg-terminals.list
    fi
}

install_tmux() {
    if [ "$(command -v tmux)" ]; then
        echo "TMUX already installed"
    else
        echo "Installing tmux tpm"
        mkdir -p ~/.tmux/plugins/
        git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm || true
    fi
}

install_starship() {
    if [ "$(command -v starship)" ]; then
        echo "Starship already installed"
    else
        echo "Installing starship"
        curl_package "https://starship.rs/install.sh"
    fi
}

install_mise() {
    if [ "$(command -v mise)" ]; then
        echo "Mise already installed"
    else
        echo "Installing mise"
        curl_package "https://mise.run"
    fi
}

install_omz() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "ZSH already installed"
    else
        echo "Installing oh my zsh and plugins"
        curl_package "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
        chsh -s "$(which zsh)"
        echo "Shell changed remember to reboot"
    fi
}

main() {
    # Set variables
    local clipboard
    clipboard=$([[ -n $WAYLAND_DISPLAY ]] && echo "wl-clipboard" || echo "xclip")

    local base_packages="zip unzip git curl neovim tmux zsh alacritty ripgrep fzf stow btop $clipboard"
    local debian_packages="$base_packages fd-find"
    local arch_packages="$base_packages fd"
    local fedora_packages="$base_packages util-linux-user fd-find"

    # Detect package manager and install packages
    echo "Installing the must-have pre-requisites"
    if [ "$(command -v apt-get)" ]; then
        echo "Detected debian"
        echo "Adding and updating repos first"
        sudo add-apt-repository universe -y >/dev/null
        sudo add-apt-repository ppa:aslatter/ppa -y >/dev/null # Alacritty
        sudo add-apt-repository ppa:neovim-ppa/unstable -y >/dev/null
        sudo apt-get update >/dev/null
        # shellcheck disable=SC2086
        sudo apt-get install -y $debian_packages
    elif [ "$(command -v dnf)" ]; then
        echo "Detected Fedora"
        # shellcheck disable=SC2086
        sudo dnf install -y $fedora_packages
    elif [ "$(command -v pacman)" ]; then
        echo "Detected Arch"
        # shellcheck disable=SC2086
        sudo pacman -Syu $arch_packages
    fi

    # Install applications if not already installed
    install_kitty
    install_starship
    install_tmux
    install_mise
    install_omz

    # Run dot_sync.sh
    "$(dirname "$(readlink -f "$0")")"/dot_sync.sh
}

main
