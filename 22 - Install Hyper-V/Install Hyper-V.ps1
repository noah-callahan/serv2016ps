
### HV1-NUG (Desktop) ###

# install Hyper-V remotely
Install-WindowsFeature -ComputerName HV1-NUG -Name Hyper-V -IncludeManagementTools -Restart


### HV2-NUG (Nano) ###

# enter remote session
Enter-PSSession -ComputerName HV2-NUG

# import provider, view installed and available packages
Import-PackageProvider -Name NanoServerPackage
Get-Package -ProviderName NanoServerPackage
Find-Package -ProviderName NanoServerPackage

# install the hyper-v role
Install-NanoServerPackage -Name Microsoft-NanoServer-Compute-Package

# reboot
Restart-Computer


### ADMIN-NUG (Local) ###

# install GUI and PS tools
Get-WindowsOptionalFeature -Online -FeatureName *Hyper-V*
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All -All