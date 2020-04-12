# A script to disable all but keyboards from waking computer from sleep
# Need to create an object with property "DeviceName" to filter out Keyboards
#TODO: Expand "Get" function to show last thing to wake your PC.
#TODO: Could include Scheduled jobs or Scheduled Tasks - is there a way to deal with them?
# powercfg -lastwake <-- shows what last woke the computer
# powercfg -requests <-- Shows what is currently keeping the computer awake

function Get-WakeArmedDevices {
    BEGIN {
        $wakearmeddevices = powercfg.exe -devicequery wake_armed
        if ($wakearmeddevices -eq "NONE") {
            throw "No devices are wake-armed!" # could this be done better?
        } else {
            # Query always adds a blank entry at the end - this removes it
            $entrytoremove = ($wakearmeddevices.count) - 1
            $wakearmeddevices[$entrytoremove] = $null
        } #if
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
        [switch]$IncludeKeyboards = $false
        # [Parameter(Mandatory = $false,
        #     ValueFromPipeline = $true)]
        # [PSTypeName("Custom.SB.WakeArmedDevice")][Object[]]$DeviceName
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
                Write-Verbose "Disabling [$wakearmeddevice]..."
                powercfg.exe -devicedisablewake "$wakearmeddevice"
                $wakearmeddevice | Out-File $logfilename -Append
            } #shouldprocess
        } #foreach
    } #process

    END {
        Get-Content $logfilename
        Write-Host "All above devices prevented from waking the computer from sleep." -ForegroundColor Green
        Write-Host "If you wish to revert this operation, the log file path is: [$logfilename]" -ForegroundColor Green
        Write-Host "Do so by using the command:" -ForegroundColor Green
        Write-Host "Undo-DisableSleepWakers -LogFilePath $logfilename" -ForegroundColor Yellow
    }

} #function

function Undo-DisableSleepWakers {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [ValidateScript( {
                if (-Not ($_ | Test-Path) ) {
                    throw "File or folder does not exist"
                }
                if ($_ -notmatch "(\.txt)") {
                    throw "The file specified in the path argument must be of type txt "
                }
                return $true
            })]
        [Parameter(Mandatory = $true)]
        [string]$LogFilePath
    )

    $wakedisableddevices = Get-Content -Path $LogFilePath

    foreach ($wakedisableddevice in $wakedisableddevices) {
        if ($PSCmdlet.ShouldProcess("Device: [$wakedisableddevice]", "Enabling Wake from Sleep")) {
            Write-Host "Re-enabling [$wakedisableddevice]..." -ForegroundColor Green
            powercfg -deviceenablewake "$wakedisableddevice"
        } #shouldprocess
    } #foreach
} #function