
### DISM - Deployment Image Servicing and Management PowerShell Cmdlets ###

## .wim ##

# view cmdlets in DISM module
Get-Command -Module DISM

# view images within a .wim
Get-WindowsImage -ImagePath .\images\install.wim
Get-WindowsImage -ImagePath .\images\nanoserver.wim

# mount server core datacenter image
Mount-WindowsImage -ImagePath .\images\install.wim -Path .\mount -Index 3

# add drivers (.inf)
Get-WindowsDriver -Path .\mount
Add-WindowsDriver -Path .\mount -Driver .\drivers\iaStorAC.inf

# add packages (.msu or .cab)
Get-WindowsPackage -Path .\mount
Add-WindowsPackage -Path .\mount -PackagePath .\updates\windows10.0-kb3150513.msu

# install roles and features
Get-WindowsOptionalFeature -Path .\mount -FeatureName dhcpserver
Enable-WindowsOptionalFeature -Path .\mount -FeatureName dhcpserver
Disable-WindowsOptionalFeature -Path .\mount -FeatureName dhcpserver

# dismount and commit changes
Dismount-WindowsImage -Path .\mount -Save


## .vhd/vhdx ##

# mount nano server datacenter vhd
Mount-WindowsImage -ImagePath .\image\nanoserver.wim -Path .\mount -Index 2

# add iis package
Add-WindowsPackage -Path .\mount -PackagePath d:\nanoserver\packages\microsoft-nanoserver-iis-package.cab

# dismount and commit changes
Dismount-WindowsImage -Path .\mount -Save