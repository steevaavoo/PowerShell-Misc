# VSCode
# Extensions
Write-Host 'Installing VS Code extensions...' -ForegroundColor 'Yellow'
$codeCmdPath = Join-Path -Path $env:ProgramFiles -ChildPath 'Microsoft VS Code\bin\code.cmd'
$extensions = 'shan.code-settings-sync'

foreach ($extension in $extensions) {
    Write-Host "`nInstalling extension $extension..." -ForegroundColor 'Yellow'
    & $codeCmdPath --install-extension $extension
}