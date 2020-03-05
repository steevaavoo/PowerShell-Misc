$IPAddress = "192.168.16.1" # to be customised - must fit in Hyper-V subnet 255.255.255.240 (/28)
$GWAddress = "192.168.16.250" # to be customised
$NewComputerName = "RODC01" # to be customised

Rename-Computer -NewName $NewComputerName -Confirm:$false -Verbose
Restart-Computer

$InterfaceAlias = (Get-NetAdapter).InterfaceAlias
New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength 28 -DefaultGateway $GWAddress

# All DCs

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -Verbose

Import-Module ADDSDeployment -Verbose

# Writeable DCs

$ADParams = @{
    CreateDnsDelegation  = $false
    DatabasePath         = "C:\Windows\NTDS"
    DomainMode           = "WinThreshold"
    DomainName           = "internal.cookingloose.co.uk"
    DomainNetbiosName    = "COOKINGLOOSE"
    ForestMode           = "WinThreshold"
    InstallDns           = $true
    LogPath              = "C:\Windows\NTDS"
    NoRebootOnCompletion = $false
    SysvolPath           = "C:\Windows\SYSVOL"
    Force                = $true
    Verbose              = $true
}

Install-ADDSForest @ADParams

# RODCs
$SiteName = "Portishead" #To be customised
$RODCParams = @{
    DomainName                       = "internal.cookingloose.co.uk"
    SiteName                         = $SiteName
    Credential                       = (Get-Credential)
    ApplicationPartitionsToReplicate = "*"
    ReadOnlyReplica                  = $true
    NoGlobalCatalog                  = $true
    InstallDns                       = $true
    NoRebootOnCompletion             = $false
    ReplicationSourceDC              = "dc01.internal.cookingloose.co.uk"
    Force                            = $true
    Verbose                          = $true
}

Install-ADDSDomainController @RODCParams

Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses ("$IPAddress") # may not be necessary
