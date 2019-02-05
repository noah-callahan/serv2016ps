
# import nano server ps bits into session
Import-Module D:\NanoServer\NanoServerImageGenerator -Verbose


## NANO1-NUG ##
# create a basic nano server vhdx
New-NanoServerImage -MediaPath D: -BasePath .\Base -TargetPath .\NANO1-NUG.vhdx -DeploymentType Guest -Edition Datacenter -ComputerName NANO1-NUG -AdministratorPassword (ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force)

# create and start vm
New-VM -Name NANO1-NUG -VHDPath .\NANO1-NUG.vhdx -MemoryStartupBytes 1GB -Generation 2 | Start-VM

# begin a remote session using powershell direct
Enter-PSSession -VMName NANO1-NUG

# view processes, services, event logs
Get-Process
Get-Service
Get-WinEvent

# end session
Exit-PSSession


## NANO2-NUG ##
# create a nano server web server
New-NanoServerImage -MediaPath D: -BasePath .\Base -TargetPath .\NANO2-NUG.vhdx -DeploymentType Guest -Edition Datacenter -ComputerName NANO2-NUG `
                    -InterfaceNameOrIndex Ethernet -Ipv4Address 192.168.1.115 -Ipv4SubnetMask 255.255.255.0 -Ipv4Gateway 192.168.1.1 -Ipv4Dns ("192.168.1.100","8.8.8.8") `
                    -Package Microsoft-NanoServer-IIS-Package -AdministratorPassword (ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force)

# view available packages
Get-NanoServerPackage -MediaPath D:

# create and start vm
New-VM -Name NANO2-NUG -VHDPath .\NANO2-NUG.vhdx -MemoryStartupBytes 1GB -SwitchName vSwitch -Generation 2| Start-VM

# begin a remote session using powershell direct
Enter-PSSession -VMName NANO2-NUG

# view iis service, logs, files
Get-Service W3SVC
Get-WinEvent -ListLog Microsoft-IIS*
Get-ChildItem -Path C:\inetpub

# view installed packages
Get-WindowsPackage -Online

# disable firewall
Set-NetFirewallProfile -Name Public,Private,Domain -Enabled False

# exit remote session
Exit-PSSession
