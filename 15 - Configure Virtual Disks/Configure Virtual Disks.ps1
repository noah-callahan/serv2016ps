
# install hyper-v powershell cmdlets
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools

# view VHD related cmdlets
Get-Command -Module Hyper-V -Name *vhd*

# create a new dynamic vhdx
New-VHD -Path V:\Disks\data2.vhdx -SizeBytes 10GB -Dynamic

# mount it
Mount-VHD -Path V:\Disks\data2.vhdx

# initialize, partition, and format it
Initialize-Disk -Number 4 -PartitionStyle GPT -PassThru | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS

# generate many files
1..5000 | %{ ($_ * (Get-Random -Max (100))) > "d:\file$_.txt" }

# unmount it
Dismount-VHD -Path V:\Disks\data2.vhdx

# view disk information
Get-VHD -Path V:\Disks\data2.vhdx
