
# remote over to HV1-NUG
Enter-PSSession -ComputerName HV1-NUG


# create a VHDX
New-VHD -Path v:\VMs\CORE-NUG_data2.vhdx -SizeBytes 100GB -Dynamic
Add-VMHardDiskDrive -VMName CORE-NUG -Path v:\VMs\CORE-NUG_data2.vhdx -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2

# configure storage QoS
Set-VMHardDiskDrive -VMName CORE-NUG -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2 -MinimumIOPS 0 -MaximumIOPS 100

# create a pass-through disk
Add-VMScsiController -VMName CORE-NUG
Add-VMHardDiskDrive -VMName CORE-NUG -DiskNumber 1 -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 0

# create a vhd set
New-VHD -Path v:\shared.vhds -SizeBytes 100GB -Dynamic

# create a diff disk
New-VHD -Path V:\VMs\GUI-NUG_diff2.vhdx -ParentPath V:\VMs\GUI-NUG_diff1.vhdx -Differencing


# exit remote session
Exit-PSSession