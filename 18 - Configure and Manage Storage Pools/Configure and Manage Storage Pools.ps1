
# create a new storage pool
New-StoragePool -FriendlyName AllTheDisks -StorageSubSystemUniqueId (Get-StorageSubSystem).UniqueId -PhysicalDisks (Get-PhysicalDisk -CanPool $true)

# create virtual disk
New-VirtualDisk -FriendlyName CompanyData -StoragePoolFriendlyName AllTheDisks -Size 2TB -ProvisioningType Thin -ResiliencySettingName Mirror

# initialize underlying physical disks
Initialize-Disk -VirtualDisk (Get-VirtualDisk -FriendlyName CompanyData)

# partition and format volumes from virtual disk
$vd = Get-VirtualDisk -FriendlyName CompanyData | Get-Disk

$vd | 
    New-Partition -Size 100GB -Driveletter U |
            Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "User Data"

$vd |     
    New-Partition -Size 500GB -Driveletter I |
        Format-Volume -FileSystem ReFS -AllocationUnitSize 4096 -NewFileSystemLabel "IT Data"

$vd | 
    New-Partition -Size 1TB -Driveletter V |
        Format-Volume -FileSystem ReFS -AllocationUnitSize 65536 -NewFileSystemLabel "VM Data"

