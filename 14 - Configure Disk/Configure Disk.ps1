
# view storage related cmdlets
Get-Command -Module Storage

# view disks
Get-Disk

# initialize disks as GPT
Initialize-Disk -Number 2 -PartitionStyle GPT

# view partitions
Get-Partition

# partition an entire disk
New-Partition -DiskNumber 2 -UseMaximumSize -Driveletter I

# view volumes
Get-Volume

# format with a file system
Format-Volume -DriveLetter I -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "IT Data"


# format remaining disk with a single command
Get-Disk | 
    Where-Object PartitionStyle -eq "RAW" | 
        Initialize-Disk -PartitionStyle GPT -PassThru | 
            New-Partition -UseMaximumSize -Driveletter V | 
                Format-Volume -FileSystem ReFS -AllocationUnitSize 65536 -NewFileSystemLabel "VM Data"