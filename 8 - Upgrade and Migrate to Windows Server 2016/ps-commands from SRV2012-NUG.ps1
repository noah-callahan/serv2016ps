
# install the .NET 3.5 framework from the sxs store on the installation media
Get-WindowsFeature net-framework-core
Install-WindowsFeature net-framework-core -source d:\sources\sxs

# register the smt tools
.\SMT_ws12R2_amd64\smigdeploy.exe

# import smig cmdlets into session
Add-PSSnapin Microsoft.Windows.ServerManager.Migration

# stop the DHCP server service
Stop-Service -Name DHCPServer

# view roles and features eligible for migration
Get-SmigServerFeature

# create the migration store
Export-SmigServerSetting -FeatureID DHCP -Path c:\nuggetlab\migration -Verbose

# copy migration store to destination server
Copy-Item -Path c:\nuggetlab\migration -Destination \\srv2016-nug\c$\nuggetlab -Recurse
