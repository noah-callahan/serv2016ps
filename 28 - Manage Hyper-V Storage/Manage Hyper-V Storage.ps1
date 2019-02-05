# remote over to HV1-NUG
Enter-PSSession -ComputerName HV1-NUG

# install roles and features into a VHDX
Install-WindowsFeature -Name Web-Server -Vhd V:\VMs\CORE-NUG.vhdx

# compact a VHDX
Optimize-VHD -Path V:\VMs\CORE-NUG_data1.vhdx

# resize a VHDX
Resize-VHD -Path V:\VMs\CORE-NUG_data1.vhdx -SizeBytes 10GB

# modify a VHDX
Convert-VHD -Path V:\VMs\CORE-NUG_data1.vhdx -DestinationPath V:\VMs\CORE-NUG_data.vhdx -VHDType Fixed -DeleteSource

# merge diff disks
Merge-VHD -Path V:\VMs\CORE-NUG_diff2.vhdx -DestinationPath V:\VMs\CORE-NUG_diff1.vhdx


# checkpoints #
Set-VM -Name CORE-NUG -CheckpointType Production
Start-VM -VMName CORE-NUG

# create a base checkpoint
Checkpoint-VM -Name CORE-NUG -SnapshotName CORE-NUG_base

# install container feature and checkpoint
Invoke-Command -VMName CORE-NUG -ScriptBlock { Install-WindowsFeature FS-FileServer -Restart }
Checkpoint-VM -Name CORE-NUG -SnapshotName CORE-NUG_fileserver

# install data dedup and checkpoint
Invoke-Command -VMName CORE-NUG -ScriptBlock { Install-WindowsFeature FS-Data-Deduplication }
Checkpoint-VM -Name CORE-NUG -SnapshotName CORE-NUG_dedup

# view checkpoints
Get-VMSnapshot -VMName CORE-NUG

# revert back to container checkpoint
Restore-VMSnapshot -VMName CORE-NUG -Name CORE-NUG_fileserver

# revert back to base checkpoint
Restore-VMSnapshot -VMName CORE-NUG -Name CORE-NUG_base

# remove all checkpoints
Get-VMSnapshot -VMName CORE-NUG | Remove-VMSnapshot


# exit remote session
Exit-PSSession