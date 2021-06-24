# Run the below to add Exchange Management Tools to standard PowerShell Terminal via PS Remoting to the Exchange INTERNAL URI
# This, along with Connect-ExchangeOnline would allow this entire process to be run in one session.
# MAKE SURE TO UPDATE ALL PLACEHOLDERS and check variable values at each stage
$connectionuri = "http://servername.domain.local/PowerShell"
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $connectionuri -Authentication Kerberos
Import-PSSession $session
Import-Module ActiveDirectory

# Make sure the appropriate module is installed to run the below.
# Connect-ExchangeOnline - not needed in this stage
Connect-MsolService

# Prep (Phase 0) - correct the placeholders below before running

$username = 'first.last'
$domain = 'contoso.com'
$userprincipalname = "$username@$domain"
# $mailbox = Get-Mailbox -Identity $userprincipalname
$msoluser = Get-MsolUser -UserPrincipalName $userprincipalname
# companyinitialname: Example "contosocouk" - the .mail.onmicrosoft.com is automatically appended below
# (this is the correct address as it is set thusly in the Email Address Policy on the HYB server)
$companyinitialname = "contosocouk"
$remoteroutingdomain = "$companyinitialname.mail.onmicrosoft.com"
$remoteroutingaddress = "$username@$remoteroutingdomain"

# Filtering out the Company Initial Name-based addresses - the $adproxyaddresses variable will be used when creating
# the local AD user - the correct SMTP address for a successful match should already be in place as a result of this
# Moreover, the remote routing address is added automatically by the email address policy when the account is linked
# in the final steps below
$adproxyaddresses = $msoluser.ProxyAddresses | Where-Object { $_ -notlike "*$companyinitialname*" }

# Phase 1 - do soon after AAD Sync completes, to allow time for troubleshooting/checks

# Set a good user password here as the account will start enabled - match it to existing 365 password
$password = "TESTING123!"
$SecurePassword = $password | ConvertTo-SecureString -AsPlainText -Force

# Be sure to change the Path below to the appropriate OU
$aduserparams = @{
    Name              = $($msoluser.DisplayName);
    SamAccountName    = "$($msoluser.FirstName).$($msoluser.LastName)";
    Enabled           = $true
    # Path = "OU=Company Users,DC=Domain,DC=local"
    AccountPassword   = $SecurePassword
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

#TODO Here's a Mailbox Property worth knowing! "IsDirSynced"

# Create user with above splatted parameters
New-AdUser @aduserparams -WhatIf

# Set AD user's Email Addresses to match those extracted from Exchange Online
Set-ADUser $aduserparams.samAccountName -replace @{proxyaddresses = $adproxyaddresses }

# Add user to standard groups (rename placeholders accordingly using shown syntax)
$groups = 'group1', 'group2', 'group3'

foreach ($group in $groups) {
    Add-ADGroupMember -Identity $group -Members $aduserparams.samAccountName
}

# Add user to non-standard groups using ADUC.

# Phase 2 - do after the mailbox is linked successfully (after AD Sync)

# Run the below on Exchange Online to get the Remote Mailbox GUID:
Connect-ExchangeOnline

Get-Mailbox $userprincipalname | Format-List ExchangeGuid
$remoteguid = Get-Mailbox $userprincipalname | Select-Object -ExpandProperty ExchangeGuid

# Do the below to avoid remoting confusion between Exchange Online and On-Prem
Get-PSSession | Remove-PSSession

# Run the below on Hybrid Server Exchange Powershell to link the local User to the remote mailbox - this will allow local management of the mailbox
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $connectionuri -Authentication Kerberos
Import-PSSession $session

Enable-RemoteMailbox $username -RemoteRoutingAddress $remoteroutingaddress

Set-RemoteMailbox $username -ExchangeGuid $remoteguid.Guid
