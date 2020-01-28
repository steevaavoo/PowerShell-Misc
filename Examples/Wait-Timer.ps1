$TaskTimeoutSec = 5

$StartTime = Get-Date
$CurrentTime = ((Get-Date).TimeOfDay.TotalSeconds)
$endtime = $StartTime.TimeOfDay.TotalSeconds + $TaskTimeoutSec

while ( $CurrentTime -lt $endtime ) {
    Start-Sleep -Seconds 1
    Write-Host "Awaiting timeout..." -ForegroundColor Green
    $CurrentTime = ((Get-Date).TimeOfDay.TotalSeconds)
}