#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

script_dir() {
    dirname "$(readlink -f "$0")"
}

curl_package() {
    local url="$1"
    local args="$2"
    curl -sSL "$url" | sh /dev/stdin "$args" >/dev/null
}

install_brew() {
    if [ "$(command -v brew)" ]; then
        echo "Homebrew already installed"
    else
        echo "Installing Homebrew"
        curl_package "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    fi
}

install_mise() {
    if [ "$(command -v mise)" ]; then
        echo "Mise already installed"
    else
        echo "Installing mise"
        curl_package "https://mise.run"
        mise install
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

install_tmux() {
    if [ "$(command -v tmux)" ]; then
        echo "TMUX already installed"
    else
        echo "Installing tmux tpm"
        mkdir -p ~/.tmux/plugins/
        git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm || true
    fi
}

install_omz() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "ZSH already installed"
    else
        echo "Installing oh my zsh and plugins"
        curl_package "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    fi
}

main() {
    if [ "$(uname)" = "Darwin" ]; then
        install_brew

        echo "Updating Homebrew"
        brew update

        echo "Installing brew packages"
        brew bundle --file="$(script_dir)/../Brewfile"
    elif [ "$(uname)" = "Linux" ]; then
        local clipboard
        clipboard=$([[ -n $WAYLAND_DISPLAY ]] && echo "wl-clipboard" || echo "xclip")

        local base_packages="zip unzip git curl zsh stow $clipboard"
        local debian_packages="$base_packages fd-find"
        local arch_packages="$base_packages fd"
        local fedora_packages="$base_packages util-linux-user fd-find"

        echo "Installing the must-have pre-requisites"
        if [ "$(command -v apt-get)" ]; then
            echo "Detected debian"
            echo "Adding and updating repos first"
            sudo add-apt-repository universe -y >/dev/null
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

        # Change shell
        chsh -s "$(which fish)"
        echo "Shell changed remember to reboot"
    fi

    install_mise
    install_omz
    install_starship
    install_tmux

    # Run dot_sync.sh
    "$(script_dir)"/dot_sync.sh
}

main
