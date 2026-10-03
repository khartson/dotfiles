#!/usr/bin/env bash
# OS packages chezmoi can't provide itself: zsh (apt) and mise (mise.run).
set -euo pipefail

need_cmd() {
    command -v "$1" >/dev/null 2>&1
}

if ! need_cmd zsh; then
    if need_cmd apt-get; then
        echo "Installing zsh via apt..."
        sudo apt-get update -qq
        sudo apt-get install -y zsh
    else
        echo "Error: zsh is required. Install it, then re-run chezmoi apply" >&2
        exit 1
    fi
fi

if ! need_cmd mise && [[ ! -x "${HOME}/.local/bin/mise" ]]; then
    echo "Installing mise to ~/.local/bin..."
    curl -fsSL https://mise.run | sh
fi
