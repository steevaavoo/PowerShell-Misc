# Connecting to EXOL
Connect-sbExopsSession

# Getting List of Mailbox Aliases
Get-Mailbox | Select-Object Alias

# Filtering for specific mailboxes into a variable for use later
$identities = Get-Mailbox | Where-Object Alias -like "*example*" | Select-Object -ExpandProperty Alias

# Getting the autoreply from a file into a variable (HTML format, single line, or plain text)
$ooo = (Get-Content -Path ~\desktop\ooo.txt)
$ooo = "The office is now closed until [insert date and time]."

$identities = "person.1", "person.2", "person.3"
# US date format required
$starttime = "12/24/2020 12:00 PM"
$endtime = "01/04/2021 8:00 AM"
$autoreplystate = "Scheduled"

Get-MailboxAutoReplyConfiguration -Identity $identity

foreach ($identity in $identities) {
    Set-MailboxAutoReplyConfiguration -Identity $identity -InternalMessage $ooo -ExternalMessage $ooo -ExternalAudience All -StartTime $starttime -EndTime $endtime -AutoReplyState $autoreplystate
}

# Disconnecting from EXOL
Get-PSSession | Remove-PSSession
