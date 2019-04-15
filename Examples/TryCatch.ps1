function Test-TryCatch {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [alias('HostName', 'MachineName')]
        $ComputerName,

        $LogFilePath
    )

    Begin {
        # Initial attempts to be over wsman

    }

    Process {
        $protocol = 'Wsman'
        do {
            Write-Verbose "Connecting to $ComputerName on $protocol"
            try {
                $sessionoption = New-CimSessionOption -Protocol $protocol
                $sessionparams = @{
                    'ComputerName'  = $ComputerName
                    'SessionOption' = $sessionoption
                    'ErrorAction'   = 'Stop'
                }
                $cimsession = New-CimSession @sessionparams
                Get-CimInstance -CimSession $cimsession -ClassName Win32_Service | Select-Object -First 1
            # Cleaning up
            Write-Verbose "Closing connection to $ComputerName"
            $cimsession | Remove-CimSession
        # Stopping if this succeeds
        $protocol = 'Stop'
    } catch {
        Write-Warning "Could not connect to $ComputerName over $protocol..."
        switch ($protocol) {
            'Wsman' { $protocol = 'Dcom' }
            'Dcom' {
                $protocol = 'Stop'
                if ($PSBoundParameters.ContainsKey('LogFilePath')) {
                    Write-Warning "All connections to $ComputerName failed, logging to $LogFilePath"
                } else {
                    Write-Warning "All connections to $ComputerName failed, no log requested"
                } #iflogging
            }
        } #switch

    } #trycatch

} Until ($protocol -eq 'Stop')

} #process

End {
    # Intentionally empty
}

} #function