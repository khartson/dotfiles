#!/usr/bin/env bash

set -e

# Ensure GNU Stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is required but not installed."
    exit 1
fi

echo "Stowing configurations..."

stow -v -R zsh
stow -v -R git 
stow -v -R tmux 

echo "Dotfiles successfully symlinked via Stow!"