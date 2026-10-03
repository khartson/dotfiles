# Packages chezmoi can't provide itself: git and mise (winget).
$ErrorActionPreference = 'Stop'

$packages = [ordered]@{ git = 'Git.Git'; mise = 'jdx.mise' }
foreach ($cmd in $packages.Keys) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $cmd via winget..."
        winget install --id $packages[$cmd] --exact --source winget `
            --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) { throw "winget install $($packages[$cmd]) failed" }
    }
}
