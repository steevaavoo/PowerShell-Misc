# Setup PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Install latest PackageManagement modules
Install-Module -Name PackageManagement -Force -Verbose
Install-Module -Name PowerShellGet -Force -Verbose

# Start a new PowerShell session

# Install VSCode Settings Sync
# VSCode
# Extensions
Write-Host 'Installing VS Code extensions...' -ForegroundColor 'Yellow'
$codeCmdPath = Join-Path -Path $env:ProgramFiles -ChildPath 'Microsoft VS Code\bin\code.cmd'
$extensions = 'shan.code-settings-sync'

foreach ($extension in $extensions) {
    Write-Host "`nInstalling extension $extension..." -ForegroundColor 'Yellow'
    & $codeCmdPath --install-extension $extension
}

# Install other modules
$moduleNames = @(
    'Az'
    'EditorServicesCommandSuite' # You should load this in your PowerShell profile for VSCode
    'PSScriptAnalyzer'
    'posh-git'
    'pscolor'
    # 'PSReadLine'
)
Install-Module -Name $moduleNames -Force -Verbose

# Install latest Pester - skip publisher check due to conflict with pre-installed version
Install-Module -Name Pester -Force -Verbose -SkipPublisherCheck