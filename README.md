# Dotfiles

Linux user environment for this machine, Proxmox SSH boxes, and
[dev-containers](https://github.com/khartson/dev-containers). Native Windows /
PowerShell is out of scope; on a work Windows box use a Linux container or SSH
instead.

## Layout

| Package | What it maps to |
| --- | --- |
| `zsh/` | `~/.zshrc` |
| `git/` | `~/.gitconfig` |
| `tmux/` | `~/.tmux.conf` |
| `mise/` | `~/.config/mise/config.toml` |

[mise](https://mise.jdx.dev/) is the version manager: Node, Python, and Ruby
instead of nvm/pyenv/rvm, plus CLIs (kubectl, helm, argocd, talosctl,
terraform, starship). Docker, Tailscale, and other services stay with the OS.

## Bootstrap

Needs `curl`, `git`, and either GNU Stow or `sudo apt-get` (Debian/Ubuntu).

```bash
git clone https://github.com/khartson/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

That installs mise if needed, stows the packages, then runs `mise install`.

Update tools later:

```bash
mise upgrade
```

Bump language versions by editing `mise/.config/mise/config.toml` and committing.
