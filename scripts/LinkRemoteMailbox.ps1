# Run the below on Exchange Online to get the Remote Mailbox GUID:
# Connect-sbExopsSession
Get-Mailbox user.name | Format-List ExchangeGuid
$remoteguid = Get-Mailbox user.name | Select-Object -ExpandProperty ExchangeGuid
$remoteguid.Guid | Set-Clipboard

# Run the below on Hybrid Server Exchange Powershell to link the local User to the remote mailbox
Enable-RemoteMailbox user.name -RemoteRoutingAddress user.name@companyinitialname.onmicrosoft.com

Set-RemoteMailbox user.name -ExchangeGuid PasteGuidHere
