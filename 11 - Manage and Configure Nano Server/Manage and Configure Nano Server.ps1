
## Domain join and remote management ##

# add nano-nug to trusted hosts of local machine for winrm
Set-Item WSMan:\localhost\Client\TrustedHosts "192.168.1.115"

# create a new session to nano-nug
$nano = New-PSSession -ComputerName 192.168.1.115 -Credential (Get-Credential)

# use the djoin command-line utiliy to perform an offline domain join
djoin.exe /provision /domain nuggetlab.com /machine NANO-NUG /savefile .\nuggetlab.blob

# copy blob to nano-nug
Copy-Item -Path .\nuggetlab.blob -Destination c:\ -ToSession $nano

# enter the existing remote session
Enter-PSSession -Session $nano

# perform the offline domain join 
djoin /requestodj /loadfile c:\nuggetlab.blob /windowspath c:\windows /localos

# restart to complete the process
Restart-Computer;exit


## Package management ##

# enter a new remote session to nano-nug
Enter-PSSession -ComputerName NANO-NUG

# install the nano server package provider
Install-PackageProvider NanoServerPackage

# import the nano server package provider
Import-PackageProvider NanoServerPackage

# list all packages
Find-Package -ProviderName NanoServerPackage

# install a package
Install-Package -Name Microsoft-NanoServer-Storage-Package


