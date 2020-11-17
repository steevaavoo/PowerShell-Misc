# Connecting to EXOL
Connect-sbExopsSession

# Getting List of Mailbox Aliases
Get-Mailbox | Select-Object Alias

# Getting the autoreply from a file into a variable (HTML format, single line)
$ooo = (Get-Content -Path ~\desktop\ooo.txt)

$identities = "person.1", "person.2", "person.3"
# US date format required
$starttime = "11/19/2020 12:00 PM"
$endtime = "11/19/2020 4:00 PM"
$autoreplystate = "Scheduled"

Get-MailboxAutoReplyConfiguration -Identity $identity

foreach ($identity in $identities) {
    Set-MailboxAutoReplyConfiguration -Identity $identity -InternalMessage $ooo -ExternalMessage $ooo -ExternalAudience All -StartTime $starttime -EndTime $endtime -AutoReplyState $autoreplystate
}
