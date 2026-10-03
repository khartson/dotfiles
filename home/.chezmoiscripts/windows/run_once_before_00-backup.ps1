# First apply only: move pre-existing regular files aside so chezmoi can write
# its own. Symlinks/junctions are left alone.
$ErrorActionPreference = 'Stop'

$targets = @(
    '.gitconfig'
    '.config/mise/config.toml'
    '.config/starship.toml'
    '.config/powershell/Microsoft.PowerShell_profile.ps1'
    '.agents/agents.toml'
    'Documents/PowerShell/Microsoft.PowerShell_profile.ps1'
)

$stamp = Get-Date -Format 'yyyyMMddHHmmss'
foreach ($rel in $targets) {
    $path = Join-Path $HOME $rel
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    if ($item -and -not $item.LinkType) {
        Write-Host "Backing up existing $path -> $path.bak.$stamp"
        Move-Item -LiteralPath $path -Destination "$path.bak.$stamp"
    }
}
