#!/usr/bin/env bash
# Bootstrap a fresh Linux box: install mise, then let chezmoi (run through mise)
# clone and apply this repo. All real setup lives in home/.chezmoiscripts.
#
#   curl -fsSL https://raw.githubusercontent.com/khartson/dotfiles/master/install.sh | bash
#
# Extra arguments go to `chezmoi init`, e.g. `bash -s -- --branch my-branch`.
set -euo pipefail

repo="${DOTFILES_REPO:-khartson}"

need_cmd() {
    command -v "$1" >/dev/null 2>&1
}

missing=()
for cmd in curl git; do
    need_cmd "$cmd" || missing+=("$cmd")
done
if (( ${#missing[@]} )); then
    if need_cmd apt-get; then
        echo "Installing ${missing[*]} via apt..."
        sudo apt-get update -qq
        sudo apt-get install -y "${missing[@]}"
    else
        echo "Error: ${missing[*]} required. Install, then re-run." >&2
        exit 1
    fi
fi

export PATH="${HOME}/.local/bin:${PATH}"
if ! need_cmd mise; then
    echo "Installing mise to ~/.local/bin..."
    curl -fsSL https://mise.run | sh
fi

# chezmoi isn't installed yet; mise runs it once here, and the applied mise
# config then installs it for good.
mise exec chezmoi@latest -- chezmoi init --apply "$@" "$repo"
