# Dotfiles

User environment for Linux (this machine, Proxmox SSH boxes,
[dev-containers](https://github.com/khartson/dev-containers)) and Windows,
managed with [chezmoi](https://www.chezmoi.io/) and [mise](https://mise.jdx.dev/).
On Windows the shell is PowerShell 7 (`pwsh`); the same pwsh profile also
works on Linux if pwsh is installed there.

## Layout

`.chezmoiroot` points chezmoi at `home/`; everything outside it (this README,
the bootstrap scripts) is repo-only.

| Source (`home/…`) | Target | OS |
| --- | --- | --- |
| `dot_zshrc` | `~/.zshrc` | Linux |
| `dot_tmux.conf` | `~/.tmux.conf` | Linux |
| `dot_gitconfig` | `~/.gitconfig` | all |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | all |
| `dot_config/starship.toml` | `~/.config/starship.toml` | all |
| `dot_config/powershell/Microsoft.PowerShell_profile.ps1` | pwsh profile | all |
| `Documents/PowerShell/Microsoft.PowerShell_profile.ps1` | stub that loads the profile above | Windows |
| `dot_agents/agents.toml` | `~/.agents/agents.toml` | all |
| `.chezmoiexternal.toml.tmpl` | `~/.oh-my-zsh` + fast-syntax-highlighting | Linux |
| `.chezmoiscripts/{linux,windows}/` | setup scripts (below) | per OS |

OS gating lives in `home/.chezmoiignore`.

Setup scripts run during `chezmoi apply`, in this order:

1. `run_once_before_00-backup`: on the first apply, moves pre-existing regular files at managed paths to `*.bak.<timestamp>`.
2. `run_onchange_before_10-packages`: installs zsh (apt) and mise on Linux, or git and mise (winget) on Windows.
3. Files and externals are written.
4. `run_onchange_after_20-mise-install`: runs `mise trust` + `mise install`. It re-runs automatically whenever the mise config changes.
5. `run_once_after_90-next-steps`: prints follow-up hints.

mise is the version manager: Node, Python, and Ruby instead of nvm/pyenv/rvm,
plus CLIs (kubectl, helm, argocd, talosctl, terraform, starship, chezmoi,
dotagents). Docker, Tailscale, and other services stay with the OS.

npm registry CLIs are installed with mise's embedded [aube](https://mise.jdx.dev/dev-tools/backends/npm.html)
installer (`npm.package_manager = "aube"`), not `npm install -g`. Node is
still the runtime. `@sentry/dotagents` is pinned that way. Its global config
stays at the default `~/.agents/`; only `agents.toml` is managed. Skills, the
lockfile, and per-agent links are created later with `dotagents install`, and
`dotagents init` is not part of bootstrap.

## Bootstrap

Linux (needs `curl`, plus `git` or `sudo apt-get`):

```bash
curl -fsSL https://raw.githubusercontent.com/khartson/dotfiles/master/install.sh | bash
```

Windows (needs winget):

```powershell
irm https://raw.githubusercontent.com/khartson/dotfiles/master/install.ps1 | iex
```

The bootstrap scripts only install mise (and, on Windows, git and pwsh), then
run `chezmoi init --apply khartson` through mise. The repo is cloned to
`~/.local/share/chezmoi`. If chezmoi is already installed, running that command
directly does the same thing. On Windows, pwsh must be installed first,
because the setup scripts run under it.

On Linux, if `zsh` isn't your login shell yet, run `chsh -s $(which zsh)` and
open a new terminal so `.zshrc` (and therefore `mise`/`starship`) activates.
On a machine where you use coding agents, apply skills with `dotagents install`.

## Day to day

```bash
chezmoi edit ~/.zshrc     # edit the source, then:
chezmoi apply             # write changes to ~
chezmoi cd                # shell in the source repo to commit/push
chezmoi update            # pull + apply on other machines
mise upgrade              # update tools
```

Bump language versions by editing `home/dot_config/mise/config.toml`. The next
`chezmoi apply` runs `mise install`.

## Migrating a machine set up with the old Stow layout

```bash
cd ~/dotfiles && stow -D zsh git tmux mise starship agents   # remove symlinks
curl -fsSL https://raw.githubusercontent.com/khartson/dotfiles/master/install.sh | bash
rm -rf ~/dotfiles                                             # once happy
```

The old `~/.oh-my-zsh` git clone is replaced by the chezmoi-managed archive.
