function Start-sbMiniKube {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [INT]$Cpus = 2,
        [Parameter(mandatory = $false)]
        [INT]$Memory = 8192
    )

    Write-Verbose "Checking current drive location - Minikube VM will not start if 'minikube start' not run from C:\"
    $currentlocation = Get-Location
    $currentdrive = $currentlocation.Drive.Root
    if ($currentdrive -ne 'C:\') {
        Write-Verbose "Current drive is [$currentdrive], switching to C:\"
        Set-Location C:\
    } else {
        Write-Verbose "Current drive already C:\, continuing"
    } #if location

    Write-Verbose 'Checking for running Minikube VM'
    $minikubestatus = minikube status

    if (!($minikubestatus -contains 'host: Running')) {
        Write-Verbose "Minikube VM not running - starting with specified parameters..."
        Write-Host "Starting MiniKube with [$Cpus] Cores and [$Memory] MB RAM" -ForegroundColor Green
        minikube.exe start --cpus $Cpus --memory $Memory
        Write-Host "Declaring Docker Environment Variables" -ForegroundColor Green
        & minikube docker-env | Invoke-Expression
    } else {
        Write-Verbose 'MiniKube VM already running'
        Write-Verbose 'Declaring Docker Environment Variables in case missed'
        & minikube docker-env | Invoke-Expression
    } #if minikubestatus

    Write-Verbose "Initiating login to Docker..."

    docker login

    Write-Host 'Ready' -ForegroundColor Green

    Write-Verbose "Returning to original path: [$currentlocation]..."
    Set-Location $currentlocation

} #function