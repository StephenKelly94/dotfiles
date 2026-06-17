#!/usr/bin/env bash
# Linux system-package lists and install dispatch.
# macOS packages live in the Brewfile instead.
# Depends on helpers from os.sh (detect_clipboard).

# Install base system packages for the given package manager.
# Usage: install_system_packages <apt|dnf|pacman>
install_system_packages() {
    local pkg_manager="$1"
    local clipboard
    clipboard="$(detect_clipboard)"

    # Common across every distro; per-distro extras appended below.
    local base_packages="zip unzip git curl zsh stow $clipboard"

    case "$pkg_manager" in
        apt)
            echo "Detected Debian/Ubuntu"
            echo "Adding and updating repos first"
            sudo add-apt-repository universe -y >/dev/null
            sudo apt-get update >/dev/null
            # shellcheck disable=SC2086
            sudo apt-get install -y $base_packages fd-find build-essential
            ;;
        dnf)
            echo "Detected Fedora"
            sudo dnf group install -y development-tools
            # shellcheck disable=SC2086
            sudo dnf install -y $base_packages util-linux-user fd-find
            ;;
        pacman)
            echo "Detected Arch"
            # shellcheck disable=SC2086
            sudo pacman -Syu --noconfirm $base_packages fd base-devel
            ;;
        *)
            echo "No supported package manager found; skipping system packages" >&2
            return 1
            ;;
    esac
}
