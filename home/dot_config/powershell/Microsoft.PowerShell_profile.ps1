# PowerShell 7 (pwsh) profile, shared by Windows and Linux. On Linux pwsh loads
# this file directly; on Windows ~/Documents/PowerShell's profile dot-sources it.

# ==========================================
# Path Adjustments
# ==========================================
$localBin = Join-Path $HOME '.local/bin'
if (Test-Path $localBin) {
    $env:PATH = $localBin + [IO.Path]::PathSeparator + $env:PATH
}

# ==========================================
# History & Keybindings (PSReadLine)
# ==========================================
# Vi-mode, like `bindkey -v` in .zshrc. Completion is case-insensitive by default.
if (Get-Module -ListAvailable -Name PSReadLine) {
    Set-PSReadLineOption -EditMode Vi -MaximumHistoryCount 1000 -HistorySaveStyle SaveIncrementally
}

# ==========================================
# Toolchain (mise) + prompt
# ==========================================
if (Get-Command mise -ErrorAction SilentlyContinue) {
    (& mise activate pwsh) | Out-String | Invoke-Expression
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}
