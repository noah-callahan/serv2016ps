
# start powershell session on HV1-NUG
Enter-PSSession HV1-NUG

# create generation 2 VM
New-VM -Name GUI-NUG -MemoryStartupBytes 2GB -NewVHDPath V:\VMs\GUI-NUG.vhdx -NewVHDSizeBytes 40GB -Generation 2

# add SCSI controller for DVD drive
Add-VMScsiController -VMName GUI-NUG

# add DVD drive to SCSI controller with Server 2016 installation media mounted
Add-VMDvdDrive -VMName GUI-NUG -ControllerNumber 1 -ControllerLocation 0 -Path V:\ISOs\WindowsServer2016.ISO

# create another virtual hard disk for data drive
New-VHD -Path V:\VMs\GUI-NUG_data1.vhdx -SizeBytes 100GB -Dynamic

# attach data disk
Add-VMHardDiskDrive -VMName GUI-NUG -Path V:\VMs\GUI-NUG_data1.vhdx

# start the VM
Start-VM -Name GUI-NUG

# exit powershell session
Exit-PSSession

# launch virtual machine connection
vmconnect