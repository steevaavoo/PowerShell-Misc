function Get-TestObject {
    foreach ($i in 1..10) {
        # Creating the custom object
        $obj = [PSCustomObject]@{
            PSTypeName = "sbSession"
            ID         = "$i"
            Session    = "$i"
        }

        # Outputting the custom object
        Write-Output -InputObject $obj
    } #foreach
} #function

function Set-TestObject {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSTypeName('sbSession')]$sessiondetails
    )
    Begin {
        # Deliberately left empty
    }

    Process {
        Write-Host "Doing something with ID $($sessiondetails.id) and Session $($sessiondetails.session)"
    }

    End {
        # Deliberately left empty
    }

} #function