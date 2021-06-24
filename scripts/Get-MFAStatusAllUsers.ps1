$Result = @()
$users = Get-MsolUser -All
$users | ForEach-Object {
    $user = $_
    $mfaStatus = $_.StrongAuthenticationRequirements.State
    $methodTypes = $_.StrongAuthenticationMethods

    if ($mfaStatus -ne $null -or $methodTypes -ne $null) {
        if ($mfaStatus -eq $null) {
            $mfaStatus = 'Enabled (Conditional Access)'
        }
        $authMethods = $methodTypes.MethodType
        $defaultAuthMethod = ($methodTypes | where { $_.IsDefault -eq "True" }).MethodType
        $verifyEmail = $user.StrongAuthenticationUserDetails.Email
        $phoneNumber = $user.StrongAuthenticationUserDetails.PhoneNumber
        $alternativePhoneNumber = $user.StrongAuthenticationUserDetails.AlternativePhoneNumber
    } Else {
        $mfaStatus = "Disabled"
        $defaultAuthMethod = $null
        $verifyEmail = $null
        $phoneNumber = $null
        $alternativePhoneNumber = $null
    }

    $Result += New-Object PSObject -property @{
        UserName               = $user.DisplayName
        UserPrincipalName      = $user.UserPrincipalName
        MFAStatus              = $mfaStatus
        AuthenticationMethods  = $authMethods
        DefaultAuthMethod      = $defaultAuthMethod
        MFAEmail               = $verifyEmail
        PhoneNumber            = $phoneNumber
        AlternativePhoneNumber = $alternativePhoneNumber
    }
}
$Result | Select-Object UserName, MFAStatus, MFAEmail, PhoneNumber, AlternativePhoneNumber
