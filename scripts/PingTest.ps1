$targethost = "192.168.1.251"

while (1) {
    $pingresult = (Test-Connection $targethost -Count 1 -Quiet -ErrorAction SilentlyContinue -InformationAction Ignore)

    if ($pingresult -eq $True) {
        Write-Host "$(Get-Date -Format 'dd-MM-yy hh:mm:ss'): Ping to [$targethost] Succeeded" -ForegroundColor Green
    } else {
        Write-Host "$(Get-Date -Format 'dd-MM-yy hh:mm:ss'): Ping to [$targethost] Failed" -ForegroundColor Red
    }

    Start-Sleep -Seconds 1
}