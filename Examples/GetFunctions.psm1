function Get-Functions {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true)]
        $ModuleName
    )

    Import-Module $ModuleName
    $functions = (Get-Command -Module ManageRDSessions | Select-Object -ExpandProperty Name)
    $functions = "'$($functions -join "','")'"
    $functions | clip
}