
# view server migration tools feature
Get-WindowsFeature -Name migration

# install windows server migration tools
Install-WindowsFeature -Name migration

# navigate to smt directory
cd \windows\system32\servermigrationtools

# generate package for source machine
.\smigdeploy.exe /package /architecture amd64 /os WS12R2 /path C:\Nuggetlab

# copy package over to source machine
Copy-Item -Path c:\nuggetlab\SMT_ws12R2_amd64 -Destination \\srv2012-nug\c$\nuggetlab -Recurse


### complete steps on SRV2012-NUG (source machine) before going further ###

# import smig cmdlets into session
Add-PSSnapin Microsoft.Windows.ServerManager.Migration

# install DHCP role and import settings!
Import-SmigServerSetting -FeatureID DHCP -Path c:\nuggetlab\migration -Verbose -Force