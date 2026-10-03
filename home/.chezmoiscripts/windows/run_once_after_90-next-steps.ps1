Write-Host ''
Write-Host 'Dotfiles applied and mise tools installed.'
Write-Host 'New pwsh sessions pick up mise and starship via the PowerShell profile.'
Write-Host 'Update later with: chezmoi update; mise upgrade'
Write-Host 'Agent config is applied, but skills are not installed. On a machine where you use them: dotagents install'

# chezmoi writes the profile to ~/Documents/PowerShell. If Documents is
# redirected (e.g. OneDrive), pwsh looks elsewhere; point that file at ours.
$managed = Join-Path $HOME 'Documents/PowerShell/Microsoft.PowerShell_profile.ps1'
$actual = $PROFILE.CurrentUserCurrentHost
if ($actual -and ([IO.Path]::GetFullPath($actual) -ne [IO.Path]::GetFullPath($managed))) {
    Write-Host "Your pwsh profile is $actual, not $managed. Add this line to it:"
    Write-Host "    . (Join-Path `$HOME '.config/powershell/Microsoft.PowerShell_profile.ps1')"
}
