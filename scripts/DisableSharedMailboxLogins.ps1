Connect-sbEXOPSSession
$mailboxes = get-mailbox
$sharedmailboxes = $mailboxes | Where-Object IsShared -eq $True
$sharedmailboxes

Install-Module azuread
Connect-AzureAD

$sharedmailboxes
$sharedmailboxes | Select-Object -ExpandProperty UserPrincipalName
$sharedmailboxupns = $sharedmailboxes | Select-Object -ExpandProperty UserPrincipalName
$sharedmailboxupns

foreach ($aduser in $sharedmailboxupns) {
    Write-Host $aduser
}

foreach ($aduser in $sharedmailboxupns) {
    Get-AzureAdUser -ObjectId $aduser | Select-Object UserPrincipalName, AccountEnabled
}

$azuresharedmailboxes = foreach ($aduser in $sharedmailboxupns) {
    Get-AzureAdUser -ObjectId $aduser | Select-Object UserPrincipalName, AccountEnabled
}

$enabledazuresharedmailboxes = $azuresharedmailboxes | Where-Object AccountEnabled -eq $True

foreach ($enabledazuresharedmailbox in $enabledazuresharedmailboxes) {
    Set-AzureADUser -ObjectID $enabledazuresharedmailbox.UserPrincipalName -AccountEnabled $False
}

foreach ($enabledazuresharedmailbox in $enabledazuresharedmailboxes) {
    Write-Host $enabledazuresharedmailbox.UserPrincipalName
}
