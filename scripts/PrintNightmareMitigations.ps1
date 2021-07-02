# ELEVATED SESSION REQUIRED

# Disable and Stop Spooler

Get-Service Spooler | Set-Service -StartUpType Disabled
Stop-Service Spooler
Get-Service Spooler | Select-Object Name, StartType, Status

# Enable and Start Spooler

Get-Service Spooler | Set-Service -StartUpType Automatic
Start-Service Spooler
Get-Service Spooler | Select-Object Name, StartType, Status

# ACL Deny for System on spool\drivers

# SOURCE: https://blog.truesec.com/2021/06/30/fix-for-printnightmare-cve-2021-1675-exploit-to-keep-your-print-servers-running-while-a-patch-is-not-available/

# Modified the top line to get only Access rather than including Owner setting - otherwise we get an error about
# not being allowed to set the owner in the Set-Acl stage.
$Path = "C:\Windows\System32\spool\drivers"
$Acl = (Get-Item $Path).GetAccessControl('Access')
$Ar = New-Object  System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
$Acl.AddAccessRule($Ar)
Set-Acl $Path $Acl

# ACL Deny Remove

$Path = "C:\Windows\System32\spool\drivers"
$Acl = (Get-Item $Path).GetAccessControl('Access')
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Modify", "ContainerInherit, ObjectInherit", "None", "Deny")
$Acl.RemoveAccessRule($Ar)
Set-Acl $Path $Acl