#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

SHELL_CHANGED=false
clipboard="xclip"
if [[ -n $WAYLAND_DISPLAY ]]; then
	clipboard="wl-clipboard"
fi

# stow -t $HOME .

# Remember packages: (not installed with this)
# Delta
# lazygit
# wezterm

base_packages="zip unzip git curl neovim tmux zsh ripgrep fzf alacritty stow htop $clipboard"

debian_packages="$base_packages fd-find"
arch_packages="$base_packages fd"
fedora_packages="$base_packages util-linux-user fd-find"

# Detect package manager
echo "Installing the must-have pre-requisites"

if [ $(command -v apt-get) ]; then
	echo "Detected debian"

	echo "Adding and updating repos first"
	sudo add-apt-repository universe -y >/dev/null
	# Alacritty
	sudo add-apt-repository ppa:aslatter/ppa -y >/dev/null
	sudo add-apt-repository ppa:neovim-ppa/unstable -y >/dev/null
	sudo apt-get update >/dev/null

	sudo apt-get install -y $debian_packages
elif [ $(command -v dnf) ]; then
	echo "Detected Fedora"
	sudo dnf install -y $fedora_packages
elif [ $(command -v pacman) ]; then
	echo "Detected Arch"
	sudo pacman -Syu $arch_packages
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Installing oh my zsh and plugins"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null
	ZSH_CUSTOM=$HOME/.config/zsh-custom
	# git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || true
	# git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting || true
	SHELL_CHANGED=true
else
	echo "ZSH already installed"
fi

if [ ! -f "$HOME/.tmux.conf" ]; then
	echo "Installing tmux tpm"
	mkdir -p ~/.tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm || true
else
	echo "TMUX already installed"
fi

if [ ! -f "/usr/local/bin/starship" ]; then
	echo "Installing starship"
	curl -sS https://starship.rs/install.sh | sh -s -- -f >/dev/null
else
	echo "Starship already installed"
fi

if [ "$SHELL_CHANGED" = "true" ]; then
	chsh -s $(which zsh)
	echo "Shell changed remember to reboot"
fi

$(dirname $(readlink -f $0))/dot_sync.sh
