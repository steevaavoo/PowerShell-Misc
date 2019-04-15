# Fail with log
Test-TryCatch -ComputerName localhos -LogFilePath c:\logs\log.txt -Verbose

# Fail without log
Test-TryCatch -ComputerName localhos -Verbose

# Succeed on Wsman
Test-TryCatch -ComputerName normandy-sr3 -LogFilePath c:\logs\log.txt -Verbose

# Simulate fail on Wsman and Succeed on DCOM
Stop-Service WinRM
Test-TryCatch -ComputerName normandy-sr3 -LogFilePath c:\logs\log.txt -Verbose
Start-Service WinRM