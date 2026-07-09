#!/usr/bin/env bash
set -e -o pipefail # fail on error and report it

script_dir() {
    dirname "$(readlink -f "$0")"
}

main() {
    local lib
    lib="$(script_dir)/lib"
    # shellcheck source=lib/os.sh
    source "$lib/os.sh"
    # shellcheck source=lib/packages.sh
    source "$lib/packages.sh"
    # shellcheck source=lib/tools.sh
    source "$lib/tools.sh"

    local os
    os="$(detect_os)"
    echo "Detected OS: $os"

    case "$os" in
        macos)
            install_brew
            echo "Updating Homebrew"
            brew update
            echo "Installing brew packages"
            brew bundle --file="$(script_dir)/../Brewfile"
            ;;
        linux)
            local pkg_manager
            pkg_manager="$(detect_pkg_manager)"
            echo "Installing system packages via ${pkg_manager:-unknown}"
            install_system_packages "$pkg_manager"

            chsh -s "$(command -v zsh)"
            echo "Shell changed to zsh; remember to reboot"
            ;;
        *)
            echo "Unsupported OS: $(uname -s)" >&2
            exit 1
            ;;
    esac

    # Cross-platform tools, installed outside the system package manager.
    # (starship is pinned in mise's config.toml, not installed here.)
    install_mise
    install_tmux

    # Sync dotfiles into place.
    "$(script_dir)/dot_sync.sh"

    # Set a default theme (creates the ghostty/kitty active-theme symlinks the
    # configs include; must run after dot_sync.sh has stowed themes/).
    "$(script_dir)/theme" catppuccin-frappe || true

    # Doom needs ~/.config/doom stowed first (done by dot_sync.sh above).
    if command -v emacs >/dev/null 2>&1; then
        install_doom
    else
        echo "Skipping Doom Emacs install: emacs not found on PATH"
    fi
}

main
