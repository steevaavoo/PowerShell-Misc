# Connect-ExchangeOnline

function Get-AllInboxRules {

    $mailboxes = Get-Mailbox

    foreach ( $mailbox in $mailboxes ) {

        $rules = Get-InboxRule -Mailbox $($mailbox).UserPrincipalName | Where-Object { $_.Name -ne $null }

        foreach ( $rule in $rules ) {
            $rulesummary = [PSCustomObject]@{
                User         = $rule.MailboxOwnerID
                RuleName     = $rule.Name
                Enabled      = $rule.enabled
                MarksAsRead  = $rule.MarkAsRead
                MovesMessage = $rule.MoveToFolder
                Forwards     = $rule.ForwardTo
            } #pscustomobject

            $rulesummary

        } #foreach

    } #foreach

} #function
