#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

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
    if [ "$(uname)" = "Linux" ]; then
        echo "Installing Homebrew dependencies and Linux-specific packages"
        local clipboard
        clipboard=$([[ -n $WAYLAND_DISPLAY ]] && echo "wl-clipboard" || echo "xclip")

        if [ "$(command -v apt-get)" ]; then
            sudo apt-get install -y build-essential procps curl file "$clipboard"
        elif [ "$(command -v dnf)" ]; then
            sudo dnf group install -y development-tools
            sudo dnf install -y procps-ng curl file util-linux-user "$clipboard"
        elif [ "$(command -v pacman)" ]; then
            sudo pacman -Syu base-devel procps-ng curl file "$clipboard"
        fi
    fi

    local brews=(git curl zsh stow fd zip unzip)
    local casks=(gcloud-cli)

    install_brew

    echo "Installing brew packages"
    brew install "${brews[@]}"

    echo "Installing casks"
    brew install --cask "${casks[@]}"

    install_mise
    install_omz

    # Run dot_sync.sh
    "$(dirname "$(readlink -f "$0")")"/dot_sync.sh
}

main
