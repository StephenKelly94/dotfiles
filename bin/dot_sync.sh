#!/bin/bash
set -e -o pipefail # fail on error and report it, debug all lines

# Sync dotfiles repo and ensure that dotfiles are tangled correctly afterward
cd $(dirname $(readlink -f $0))
cd ..

echo "Stashing existing changes..."
stash_result=$(git stash push -m "sync-dotfiles: Before syncing dotfiles")
is_stashed=true
if [ "$stash_result" = "No local changes to save" ]; then
	is_stashed=false
fi

echo "Pulling updates from dotfiles repo..."
git pull origin main

if [[ $is_stashed ]]; then
	echo "Popping stashed changes..."
	git stash pop
fi

unmerged_files=$(git diff --name-only --diff-filter=U)
if [[ ! -z $unmerged_files ]]; then
	echo "The following files have merge conflicts after popping the stash:"
	printf %"s\n" $unmerged_files # Ensure newlines are printed
else
	# Run stow to ensure all new dotfiles are linked
	stow -t $HOME .
fi

# Sync the submodules
git submodule update --recursive
