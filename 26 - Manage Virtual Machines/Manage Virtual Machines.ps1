
# start powershell session on HV1-NUG
Enter-PSSession HV1-NUG


### Hot/ Add/Remove Memory ###

# add more memory to both machines
Get-VM | Set-VMMemory -StartupBytes 3072
Get-VM


### Enhanced Session Mode ##

# enable enhanced session mode support on the host
Set-VMHost -EnableEnhancedSessionMode $true


### Secure Boot ###

# enable secure boot
Get-VM | Set-VMFirmware -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows # <- MicrosoftUEFICertificateAuthority (linux)
Get-VM | Get-VMFirmware


### Direct Device Assignment (DDA) ##

# DDA cmdlets
Get-Command *device* -Module Hyper-V


### Integration Services ###

# view integration services
Get-VMIntegrationService -VMName GUI-NUG

# enable guest services
Enable-VMIntegrationService -VMName GUI-NUG -Name "Guest Service Interface"


### Import & Export VMs ###

# export a vm
Export-VM -Name GUI-NUG -Path \\hv2-nug\v$\vms\exports

# import a vm
Invoke-Command -ComputerName HV2-NUG -ScriptBlock { Import-VM -Path V:\vms\exports\GUI-NUG }


### Convert VMs from Previous Versions ###

# upgrade vm version to server 2016 hyper-v (8.0)
Get-VM | Update-VMVersion


# exit powershell session on HV1-NUG
Exit-PSSession HV1-NUG