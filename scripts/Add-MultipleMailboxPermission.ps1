$mailboxname =
$displayname =
$newmailbox.alias =
$secretary =

$newmailboxes = Import-Csv -path ~\desktop\newmailboxes.csv
$newmailboxes.DisplayName

foreach ( $newmailbox in $newmailboxes ) {
    Add-RecipientPermission -Identity $newmailbox.alias -AccessRights SendAs -Trustee $newmailbox.secretary
    Add-MailboxPermission -Identity $newmailbox.alias -User $newmailbox.secretary -AccessRights FullAccess -InheritanceType All
}


$newmailboxes[0].secretary

Add-RecipientPermission -Identity $newmailbox.alias -AccessRights SendAs -Trustee $newmailbox.secretary
