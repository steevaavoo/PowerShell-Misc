Connect-ExchangeOnline
Connect-MsolService

$mailboxes = Get-Mailbox -ResultSize Unlimited
$username = "User Name"

$fullaccessmailboxes = ($mailboxes | Get-MailboxPermission -User $username).Identity

$fullaccessmailboxes

foreach ($fullaccessmailbox in $fullaccessmailboxes) {
    Remove-MailboxPermission -Identity $fullaccessmailbox -User $username -AccessRights FullAccess -Confirm:$false
}

 help remove-mailboxpermission -Online


$mailboxes | Get-RecipientPermission -Trustee $username | Format-Table User,Identity

Get-RecipientPermission -Identity "User Name"

# Grant user Full Access to multiple mailboxes

$trustee = "Trustee Name"
$mailboxes = "User1","User2","User3","User4"

foreach ($mailbox in $mailboxes) {
    Add-MailboxPermission -Identity $mailbox -User $trustee -AccessRights FullAccess -Confirm:$false
}
