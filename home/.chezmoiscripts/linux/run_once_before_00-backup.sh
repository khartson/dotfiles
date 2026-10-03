#!/usr/bin/env bash
# First apply only: move pre-existing regular files aside so chezmoi can write
# its own. Symlinks (e.g. left over from Stow) are left alone.
set -euo pipefail

targets=(
    .zshrc
    .gitconfig
    .tmux.conf
    .config/mise/config.toml
    .config/starship.toml
    .config/powershell/Microsoft.PowerShell_profile.ps1
    .agents/agents.toml
)

stamp="$(date +%Y%m%d%H%M%S)"
for rel in "${targets[@]}"; do
    path="${HOME}/${rel}"
    if [[ -e "$path" && ! -L "$path" ]]; then
        echo "Backing up existing $path -> ${path}.bak.${stamp}"
        mv "$path" "${path}.bak.${stamp}"
    fi
done
