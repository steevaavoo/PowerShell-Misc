$sb = {
    Start-Sleep -seconds 10 -Verbose
}
$jobs = 1..3 | ForEach-Object { Start-Job -ScriptBlock $sb -Name "Job$_" }
$jobs
$jobs | Wait-Job -Verbose