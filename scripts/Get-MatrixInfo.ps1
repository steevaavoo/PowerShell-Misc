# $computerinfo = Get-ComputerInfo
# $bitlockerinfo = Get-BitLockerVolume -MountPoint C:
# $tpm = Get-Tpm
# $drive = Get-PhysicalDisk -DeviceNumber 0

# $computerinfo
# $bitlockerinfo

# # We want:
# # Encrypted,TPM,Windows Version,PC / Laptop,PC / Laptop Name,SSD,CPU,Main Board or Laptop Model,Memory,Slots

# # Indicates whether Bitlocker encryption is enabled for C:
# $bitlockerinfo.ProtectionStatus

# # Indicates whether TPM is present
# $tpm.TpmPresent

# # Windows Version (friendly name)
# $computerinfo.WindowsProductName

# # Computer name, Motherboard Info and Memory
# $computerinfo.CsName
# $computerinfo.CsManufacturer
# $computerinfo.CsModel
# $computerinfo.BiosReleaseDate
# $computerinfo.CsTotalPhysicalMemory


# # Returns Drive Type, name, then size
# $drive.MediaType
# $drive.FriendlyName
# $drive.Size


function Get-MatrixInfo {

    $computerinfo = Get-ComputerInfo
    $bitlockerinfo = Get-BitLockerVolume -MountPoint C:
    $tpm = Get-Tpm
    $drive = Get-PhysicalDisk -DeviceNumber 0

    $matrixinfo = [PSCustomObject]@{
        PSTypeName             = "Custom.SB.MatrixInfo"
        EncryptionStatus       = $bitlockerinfo.ProtectionStatus
        TpmPresent             = $tpm.TpmPresent
        WindowsVersion         = $computerinfo.WindowsProductName
        ComputerName           = $computerinfo.CsName
        DriveType              = $drive.MediaType
        DriveMake              = $drive.FriendlyName
        DriveFormattedCapacity = [math]::Round($drive.Size / 1GB, 0)
        Processor              = $computerinfo.CsProcessors[0].Name
        MotherBoard            = "$($computerinfo.CsManufacturer) $($computerinfo.CsModel)"
        PhysicalMemory         = [math]::Round($computerinfo.CsTotalPhysicalMemory / 1GB, 0)
        BiosDate               = $computerinfo.BiosReleaseDate
    }

    $matrixinfo | Export-Csv -Path .\matrix.csv -Delimiter "`t"
    Get-Content .\matrix.csv | Select-Object -Skip 1 | Set-Clipboard
    Remove-Item .\matrix.csv -Force

    $matrixinfo
    Write-Host "Above info copied into clipboard. Paste into Matrix where appropriate." -ForegroundColor Green

}
