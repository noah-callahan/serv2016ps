
# enter a powershell session on a remote machine
Enter-PSSession -ComputerName CORE-NUG

# view all available features
Get-WindowsFeature

# install web server (iis) role and management service
Install-WindowsFeature -Name Web-Server, Web-Mgmt-Service

# view installed features
Get-WindowsFeature | Where-Object Installed -eq True

# configure remote management for IIS
Set-ItemProperty -Path "HKLM:\Software\Microsoft\WebManagement\Server" -Name "EnableRemoteManagement" -Value 1

# configure remote managent service to start automatically
Set-Service WMSVC -StartupType Automatic

# rename a computer
Rename-Computer -NewName WEB-NUG -DomainCredential "nuggetlab\administrator" -Force -Restart

# exit remote powershell session
Exit-PSSession

# send a command over to a remote machine (powershell remoting - http)
Invoke-Command -ComputerName WEB-NUG -ScriptBlock { Get-Service W3SVC, WMSVC }

# use the built in computername parameter (windows - dcom)
Get-Service -ComputerName WEB-NUG