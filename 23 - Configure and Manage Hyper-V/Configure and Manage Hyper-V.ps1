
# hyper-v cmdlets
Get-Command -Module Hyper-V


### Remote Hyper-V Host Management ##

# single-use remote sessions
Invoke-Command -ComputerName HV1-NUG,HV2-NUG -ScriptBlock { Get-VMHost }
Invoke-Command -ComputerName HV1-NUG,HV2-NUG -ScriptBlock { Set-VMHost -VirtualHardDiskPath V:\VMs -VirtualMachinePath V:\VMs }

# interactive remote session
Enter-PSSession -ComputerName HV1-NUG
Get-VM
Start-VM -Name GUI-NUG
Exit-PSSession

# persistent remote session
$hv2 = New-PSSession -ComputerName HV2-NUG
Enter-PSSession -Session $hv2
Get-VM
Start-VM -Name CORE-NUG
Exit-PSSession


### PowerShell Direct Virtual Machine Management ###

# single-use powershell direct session 
Invoke-Command -VMName CORE-NUG -Credential (Get-Credential) -ScriptBlock { Get-ComputerInfo }

# interactive powershell direct session
Enter-PSSession -VMName CORE-NUG -Credential (Get-Credential)
Get-WindowsFeature
Exit-PSSession

# persistent powershell direct session
$core = New-PSSession -VMName CORE-NUG -Credential (Get-Credential)
Enter-PSSession -Session $core
"this file was created on core-nug" > c:\core-nug.txt
Exit-PSSession

# copy files to/from VM
"this file was created on hv2-nug" > c:\hv2-nug.txt
Copy-Item -Path c:\hv2-nug.txt -Destination C:\ -ToSession $core
Copy-Item -Path c:\core-nug.txt -Destination C:\ -FromSession $core

# clean up sessions
Exit-PSSession
Remove-PSSession $core
Exit-PSSession
Remove-PSSession $hv2


### Nested Virtualization ###

# interactive session on HV1-NUG
Enter-PSSession -ComputerName HV1-NUG

# attempt to install Hyper-V role on GUI-NUG (fail...)
Invoke-Command -VMName GUI-NUG -ScriptBlock { Install-WindowsFeature Hyper-V -IncludeManagementTools }

# stop the vm
Stop-VM GUI-NUG

# enable nested virt on HV1-NUG for GUI-NUG VM
Set-VMProcessor -VMName GUI-NUG -ExposeVirtualizationExtensions $true

# start the vm
Start-VM GUI-NUG

# interactive session on HV1-NUG
Enter-PSSession -ComputerName HV1-NUG

# attempt to install Hyper-V role on VM (success!)
Invoke-Command -VMName GUI-NUG -ScriptBlock { Install-WindowsFeature Hyper-V -IncludeManagementTools }