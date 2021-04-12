# Run the below to add Exchange Management Tools to standard PowerShell Terminal - NOTE only run on Exchange server
# This, along with Connect-ExopsSession would allow this entire process to be run in one session.
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
Import-Module ActiveDirectory

# Make sure the appropriate module is installed to run the below.
Connect-ExchangeOnline
Connect-MsolService



# Prep (Phase 0)

$userprincipalname = 'user.name@domain.com'
$mailbox = Get-Mailbox -Identity $userprincipalname
$msoluser = Get-MsolUser -UserPrincipalName $userprincipalname
$companyinitialname = "initialnameoftenant"
$remoteroutingaddress = "$companyinitialname.onmicrosoft.com"

# Filtering out the Company Initial Name-based addresses - use the new variable when creating the local AD user
$adproxyaddresses = $msoluser.ProxyAddresses | Where-Object { $_ -notlike '*companyinitialname*' }

# Phase 1 - do soon after AAD Sync completes

$aduserparams = @{
    Name              = $($msoluser.DisplayName);
    SamAccountName    = "$($msoluser.FirstName).$($msoluser.LastName)";
    Enabled           = $false
    # Path = "OU=Users,DC=Domain,DC=local"
    # AccountPassword = $password
    GivenName         = $($msoluser.FirstName);
    Surname           = $($msoluser.LastName);
    DisplayName       = $($msoluser.DisplayName);
    UserPrincipalName = $($msoluser.UserPrincipalName);
    Office            = $($msoluser.Office);
    Department        = $($msoluser.Department);
    EmailAddress      = $($msoluser.UserPrincipalName);
    Title             = $($msoluser.Title);
    Company           = $($msoluser.Company);
    OfficePhone       = $($msoluser.PhoneNumber);
    Fax               = $($msoluser.Fax);
    MobilePhone       = $($msoluser.MobilePhone);
    Country           = $($msoluser.Country);
    OtherAttributes   = @{
        proxyAddresses = $adproxyaddresses; # This is problematic. Check other script (change proxy addresses) to find out how to make it work.
    }
}

# Create user with above splatted parameters
New-AdUser @aduserparams -WhatIf

# Add user to standard groups

# Phase 2 - do after the mailbox is linked successfully

# Run the below on Exchange Online to get the Remote Mailbox GUID:
# Connect-sbExopsSession
Get-Mailbox $userprincipalname | Format-List ExchangeGuid
$remoteguid = Get-Mailbox $userprincipalname | Select-Object -ExpandProperty ExchangeGuid
# $remoteguid.Guid | Set-Clipboard

# Run the below on Hybrid Server Exchange Powershell to link the local User to the remote mailbox
Enable-RemoteMailbox $userprincipalname -RemoteRoutingAddress $remoteroutingaddress

Set-RemoteMailbox $userprincipalname -ExchangeGuid $remoteguid.Guid
