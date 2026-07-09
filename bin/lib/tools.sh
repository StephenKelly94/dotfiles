#!/usr/bin/env bash
# Installers for tools fetched outside the system package manager.
# Each is idempotent: it no-ops if the tool is already present.

# Pipe a remote installer script to sh.
# Usage: curl_package <url> [args]
curl_package() {
    local url="$1"
    local args="$2"
    curl -sSL "$url" | sh /dev/stdin "$args" >/dev/null
}

install_brew() {
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew already installed"
    else
        echo "Installing Homebrew"
        curl_package "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    fi
}

install_mise() {
    if command -v mise >/dev/null 2>&1; then
        echo "Mise already installed"
    else
        echo "Installing mise"
        curl_package "https://mise.run"
        mise install
    fi
}

install_tmux() {
    if [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
        echo "tmux tpm already installed"
    else
        echo "Installing tmux tpm"
        mkdir -p "$HOME/.config/tmux/plugins"
        git clone https://github.com/tmux-plugins/tpm.git "$HOME/.config/tmux/plugins/tpm" || true
    fi
}

# Pinned to a tagged release for stability (master is a rolling refactor).
# `sync -e` snapshots the shell PATH so the GUI Emacs.app finds mise/brew tools.
DOOM_VERSION="v2.1.1"
install_doom() {
    local emacs_dir="$HOME/.config/emacs"
    if [ -d "$emacs_dir" ]; then
        echo "Doom Emacs already installed; syncing"
        "$emacs_dir/bin/doom" sync -e || true
    else
        echo "Installing Doom Emacs ($DOOM_VERSION)"
        git clone --branch "$DOOM_VERSION" --depth 1 https://github.com/doomemacs/doomemacs "$emacs_dir"
        yes | "$emacs_dir/bin/doom" install --no-config
        "$emacs_dir/bin/doom" sync -e || true
    fi
}

