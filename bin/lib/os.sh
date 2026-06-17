#!/usr/bin/env bash
# OS and package-manager detection helpers.
# Sourced by dot_setup.sh; defines functions only, runs nothing.

# Echo a normalized OS name: "macos", "linux", or "unknown".
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux) echo "linux" ;;
        *) echo "unknown" ;;
    esac
}

# Echo the system package manager: apt, dnf, pacman, or "" if none found.
detect_pkg_manager() {
    if command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    else
        echo ""
    fi
}

# Echo the preferred clipboard tool for the current session.
detect_clipboard() {
    if [ -n "$WAYLAND_DISPLAY" ]; then
        echo "wl-clipboard"
    else
        echo "xclip"
    fi
}
