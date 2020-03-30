# A script to disable all but keyboards from waking computer from sleep
# Need to create an object with property "DeviceName" to filter out Keyboards

function Get-WakeArmedDevices {
    BEGIN {
        $wakearmeddevices = powercfg.exe -devicequery wake_armed
        # Query always adds a blank entry at the end - this removes it
        $entrytoremove = ($wakearmeddevices.count) - 1
        $wakearmeddevices[$entrytoremove] = $null
    }

    PROCESS {

        foreach ($wakearmeddevice in $wakearmeddevices) {
            [PSCustomObject]@{
                PSTypeName = "Custom.SB.WakeArmedDevice"
                DeviceName = $wakearmeddevice
            }
        } #foreach wakearmeddevice

    } #process
} #function

function Stop-SleepWakers {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false)]
        [switch]$IncludeKeyboards = $false,
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true)]
        [PSTypeName("Custom.SB.WakeArmedDevice")][Object[]]$DeviceName
    )

    BEGIN {
        # Creating current log file
        $timestamp = Get-Date -Format "yyyyMMdd-hh.mm.ss"
        $logfilename = ".\logs\devicelog$timestamp.txt"
        Write-Verbose "Checking for log path..."
        $logpathexists = Resolve-Path .\logs -ErrorAction SilentlyContinue
        if (!($logpathexists)) {
            Write-Verbose "No log path found, creating .\logs..."
            New-Item -ItemType Directory -Path .\logs
            Write-Verbose ".\logs folder created."
        } else {
            Write-Verbose "Log path exists, continuing."
        }
        New-Item -Path $logfilename | Out-Null
    }

    PROCESS {
        if ($IncludeKeyboards) {
            $wakearmeddevices = Get-WakeArmedDevices | Select-Object -ExpandProperty DeviceName
        } else {
            $wakearmeddevices = Get-WakeArmedDevices | Where-Object DeviceName -NotLike "*Keyboard*" | Select-Object -ExpandProperty DeviceName
        }

        foreach ($wakearmeddevice in $wakearmeddevices) {
            if ($PSCmdlet.ShouldProcess("Device: [$wakearmeddevice]", "Disabling Wake from Sleep")) {
                powercfg.exe -devicedisablewake "$wakearmeddevice"
            } #shouldprocess
        } #foreach
    } #process

    END {
        notepad $logfilename
    }

} #function

function Undo-DisableSleepWakers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$LogFilePath
    )

    # Need something to validate log file, fail if not there, import log to var, supportsshouldprocess to allow user
    # to allow/deny devices to be re-enabled

} #function