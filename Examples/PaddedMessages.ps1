#region New Terraform SP (Service Principal)
Write-HostPadded -Message "Using Azure CLI to Create a Terraform Service Principle: [$servicePrincipleName] ..." -NoNewline
try {
    az ad sp create-for-rbac --name $servicePrincipleName --password $servicePrinciplePassword | Out-String | Write-Verbose
    $terraformSP = Get-AzADServicePrincipal -DisplayName  $servicePrincipleName -ErrorAction 'Stop'
} catch {
    Write-Host "ERROR!" -ForegroundColor 'Red'
    throw $_
}
Write-Host "SUCCESS!" -ForegroundColor 'Green'
#endregion New Terraform SP (Service Principal)