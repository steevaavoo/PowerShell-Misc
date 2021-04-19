$newitdeptuser = "INSERT NAME"

New-LocalUser -FullName $newitdeptuser -Name $newitdeptuser -PasswordNeverExpires

Add-LocalGroupMember -Group "Administrators" -Member $newitdeptuser
Add-LocalGroupMember -Group "Users" -Member $newitdeptuser

Remove-LocalUser -Name "user" -Confirm:$false

$newusername = "INSERT NAME"

New-LocalUser -FullName $newusername -Name $newusername -PasswordNeverExpires

Add-LocalGroupMember -Group "Administrators" -Member $newusername
Add-LocalGroupMember -Group "Users" -Member $newusername
