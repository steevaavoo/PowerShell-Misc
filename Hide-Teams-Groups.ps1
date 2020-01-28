$groups = Get-UnifiedGroup

$groups | Select-Object DisplayName, Alias, HiddenFromExchangeClientsEnabled | Sort-Object HiddenFromExchangeClientsEnabled

