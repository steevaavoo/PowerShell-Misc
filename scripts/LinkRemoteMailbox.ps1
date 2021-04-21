# Run the below to add Exchange Management Tools to standard PowerShell Terminal - NOTE only run on Exchange server
# This, along with Connect-ExchangeOnline would allow this entire process to be run in one session.
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
Import-Module ActiveDirectory

# Make sure the appropriate module is installed to run the below.
Connect-ExchangeOnline
Connect-MsolService

# Prep (Phase 0) - correct the placeholders below before running

$userprincipalname = 'user.name@domain.com'
$mailbox = Get-Mailbox -Identity $userprincipalname
$msoluser = Get-MsolUser -UserPrincipalName $userprincipalname
# companyinitialname Example "contosocouk" - the .onmicrosoft.com is automatically appended below
$companyinitialname = "initialnameoftenant"
$remoteroutingaddress = "$companyinitialname.onmicrosoft.com"

# Filtering out the Company Initial Name-based addresses - the $adproxyaddresses variable will be used when creating the local AD user - the correct SMTP address for a successful match should already be in place as a result of this
$adproxyaddresses = $msoluser.ProxyAddresses | Where-Object { $_ -notlike '*companyinitialname*' }

# Phase 1 - do soon after AAD Sync completes, to allow time for troubleshooting/checks

# Be sure to change the Path below to the appropriate OU
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
}


# Create user with above splatted parameters
New-AdUser @aduserparams -WhatIf

# Set AD user's Email Addresses to match those extracted from Exchange Online
Set-ADUser $aduserparams.samAccountName -replace @{proxyaddresses = $adproxyaddresses }

# Add user to standard groups (rename placeholders accordingly using shown syntax)
$groups = 'group1','group2','group3'

foreach($group in $groups){
    Add-ADGroupMember -Identity $group -Members $aduserparams.samAccountName
}

# Add user to non-standard groups using ADUC.

# Phase 2 - do after the mailbox is linked successfully (after AD Sync)

# Run the below on Exchange Online to get the Remote Mailbox GUID:
# Connect-ExchangeOnline
Get-Mailbox $userprincipalname | Format-List ExchangeGuid
$remoteguid = Get-Mailbox $userprincipalname | Select-Object -ExpandProperty ExchangeGuid

# Run the below on Hybrid Server Exchange Powershell to link the local User to the remote mailbox - this will allow local management of the mailbox
Enable-RemoteMailbox $userprincipalname -RemoteRoutingAddress $remoteroutingaddress

Set-RemoteMailbox $userprincipalname -ExchangeGuid $remoteguid.Guid

#TODO: Script something to change the emails for all Contraflex and Manuplas users to aisltd.com (the AD ones can be done via Email Address Policy)
