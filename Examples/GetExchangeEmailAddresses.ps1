function Get-sbExoPrimaryEmail {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$Identity = '*'
    )

    BEGIN { }

    PROCESS {
        # Getting all email recipients into a variable for quick access
        $recipients = Get-Mailbox -Identity $Identity

        foreach ($recipient in $recipients) {
            $emailaddresses = $recipient.EmailAddresses
            foreach ($emailaddress in $emailaddresses) {
                $smtpaddress = $emailaddress | Where-Object { $_ -clike '*SMTP*' }
            if ($smtpaddress) {
                $obj = [PSCustomObject]@{
                    'Name'        = $recipient.Name
                    'SMTPAddress' = $smtpaddress
                }
            } else {
                # do nothing if no SMTP address
            } #if smtpaddress exists
        } #foreach emailaddress
        Write-Output $obj
    } #foreach recipient
} #process

END { }

} #function