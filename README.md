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
| `starship/` | `~/.config/starship.toml` |
| `agents/` | `~/.agents/agents.toml` |

[mise](https://mise.jdx.dev/) is the version manager: Node, Python, and Ruby
instead of nvm/pyenv/rvm, plus CLIs (kubectl, helm, argocd, talosctl,
terraform, starship, dotagents). Docker, Tailscale, and other services stay
with the OS.

npm registry CLIs are installed with mise's embedded [aube](https://mise.jdx.dev/dev-tools/backends/npm.html)
installer (`npm.package_manager = "aube"`), not `npm install -g`. Node is
still the runtime. `@sentry/dotagents` is pinned that way. Its global config
stays at the default `~/.agents/`; only `agents.toml` is stowed. Skills, the
lockfile, and per-agent links are created later with `dotagents install`, and
`dotagents init` is not part of bootstrap.

## Bootstrap

Needs `curl`, `git`, and either GNU Stow or `sudo apt-get` (Debian/Ubuntu).

```bash
git clone https://github.com/khartson/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

That installs `zsh`, `stow`, and `mise` if needed, stows the packages, then runs
`mise install`. If `zsh` isn't your login shell yet, run `chsh -s $(which zsh)`
and open a new terminal so `.zshrc` (and therefore `mise`/`starship`) activates.
On a machine where you use coding agents, apply skills with `dotagents install`.

Update tools later:

```bash
mise upgrade
```

Bump language versions by editing `mise/.config/mise/config.toml` and committing.
