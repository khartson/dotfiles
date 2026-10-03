# Bootstrap a fresh Windows box: install git, PowerShell 7 and mise with winget,
# then let chezmoi (run through mise) clone and apply this repo. All real setup
# lives in home/.chezmoiscripts. Runs under Windows PowerShell 5.1 or pwsh 7.
#
#   irm https://raw.githubusercontent.com/khartson/dotfiles/master/install.ps1 | iex
#
# Set $env:DOTFILES_BRANCH to apply a branch other than the default.
$ErrorActionPreference = 'Stop'

$repo = if ($env:DOTFILES_REPO) { $env:DOTFILES_REPO } else { 'khartson' }

$packages = [ordered]@{ git = 'Git.Git'; pwsh = 'Microsoft.PowerShell'; mise = 'jdx.mise' }
foreach ($cmd in $packages.Keys) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $cmd via winget..."
        winget install --id $packages[$cmd] --exact --source winget `
            --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) { throw "winget install $($packages[$cmd]) failed" }
    }
}

# winget updates PATH in the registry, not in this session.
$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
            [Environment]::GetEnvironmentVariable('Path', 'User')

# chezmoi isn't installed yet; mise runs it once here, and the applied mise
# config then installs it for good.
$initArgs = @('init', '--apply')
if ($env:DOTFILES_BRANCH) { $initArgs += @('--branch', $env:DOTFILES_BRANCH) }
mise exec chezmoi@latest -- chezmoi @initArgs $repo
if ($LASTEXITCODE -ne 0) { throw 'chezmoi init --apply failed' }
