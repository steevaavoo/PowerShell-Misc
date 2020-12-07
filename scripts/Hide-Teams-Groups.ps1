# Getting all Teams Groups into a variable
$groups = Get-UnifiedGroup

# Isolating just the groups which are visible in the Global Address List and Navigation Panes in Outlook
$visiblegroups = $groups | Where-Object HiddenFromExchangeClientsEnabled -like '*false*'

# Confirming the results (all should show 'False' in HiddenFromExchangeClientsEnabled)
$visiblegroups | Select-Object alias, HiddenFromExchangeClientsEnabled

# Changing all the visible groups to be invisible
foreach ($visiblegroup in $visiblegroups ) {
    Set-UnifiedGroup -Identity $visiblegroup.identity -HiddenFromExchangeClientsEnabled
}

# Checking the status of the groups after the change
$groups = Get-UnifiedGroup
$groups | Select-Object Alias, HiddenFromExchangeClientsEnabled
