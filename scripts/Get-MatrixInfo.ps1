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

# # Computer name
# $computerinfo.CsName

# # Returns Drive Type, name, then size
# $drive.MediaType
# $drive.FriendlyName
# $drive.Size

function Get-MatrixInfo {

    $computerinfo = Get-ComputerInfo
    $bitlockerinfo = Get-BitLockerVolume -MountPoint C:
    $tpm = Get-Tpm
    $drive = Get-PhysicalDisk -DeviceNumber 0

    [PSCustomObject]@{
        PSTypeName       = "Custom.SB.MatrixInfo"
        EncryptionStatus = $bitlockerinfo.ProtectionStatus
        TpmPresent       = $tpm.TpmPresent
        WindowsVersion   = $computerinfo.WindowsProductName
        ComputerName     = $computerinfo.CsName
        DriveType        = $drive.MediaType
        DriveMake        = $drive.FriendlyName
        DriveCapacity    = $drive.Size
    }

}
