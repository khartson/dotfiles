#!/usr/bin/env bash
set -euo pipefail

echo
echo "Dotfiles applied and mise tools installed."
echo "New shells pick up mise via .zshrc (eval \"\$(mise activate zsh)\")."
echo "Update later with: chezmoi update && mise upgrade"
echo "Agent config is applied, but skills are not installed. On a machine where you use them: dotagents install"
if [[ "${SHELL:-}" != *zsh ]]; then
    echo "Your default shell is not zsh yet. Set it with: chsh -s \$(which zsh)"
    echo "(then start a new terminal so mise/starship activate)"
fi
