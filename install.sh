#!/usr/bin/env bash
# Bootstrap GNU Stow + mise, then symlink this repo and install pinned tools.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

stow_packages=(zsh git tmux mise)

need_cmd() {
    command -v "$1" >/dev/null 2>&1
}

install_stow() {
    if need_cmd stow; then
        return 0
    fi
    if need_cmd apt-get; then
        echo "Installing GNU Stow via apt..."
        sudo apt-get update -qq
        sudo apt-get install -y stow
        return 0
    fi
    echo "Error: GNU Stow is required. Install it, then re-run $0" >&2
    exit 1
}

install_mise() {
    if need_cmd mise; then
        return 0
    fi
    echo "Installing mise to ~/.local/bin..."
    curl -fsSL https://mise.run | sh
    export PATH="${HOME}/.local/bin:${PATH}"
    if ! need_cmd mise; then
        echo "Error: mise installed but not on PATH. Open a new shell or add ~/.local/bin to PATH." >&2
        exit 1
    fi
}

backup_if_regular_file() {
    local path="$1"
    if [[ -e "$path" && ! -L "$path" ]]; then
        local bak="${path}.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backing up existing $path -> $bak"
        mv "$path" "$bak"
    fi
}

install_stow
install_mise

echo "Stowing configurations..."
backup_if_regular_file "${HOME}/.zshrc"
backup_if_regular_file "${HOME}/.gitconfig"
backup_if_regular_file "${HOME}/.tmux.conf"
backup_if_regular_file "${HOME}/.config/mise/config.toml"

mkdir -p "${HOME}/.config"
for pkg in "${stow_packages[@]}"; do
    stow -v -R "$pkg"
done

echo "Installing tools from mise config..."
export PATH="${HOME}/.local/bin:${PATH}"
# Trust this repo's config (mise blocks untrusted toml by default).
if [[ -L "${HOME}/.config/mise/config.toml" || -f "${HOME}/.config/mise/config.toml" ]]; then
    mise trust "${HOME}/.config/mise/config.toml"
fi
mise install

echo
echo "Dotfiles stowed and mise tools installed."
echo "New shells pick up mise via .zshrc (eval \"\$(mise activate zsh)\")."
echo "Update later with: mise upgrade"
