
### CN1-NUG (Desktop) ###

# enter remote session
Enter-PSSession CN1-NUG

# install docker provider
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

# install docker
Install-Package -Name docker -ProviderName DockerMsftProvider -Force

# reboot
Restart-Computer -Force

# docker install & root dir
Get-ChildItem -Name 'C:\Program Files\Docker'
Get-ChildItem -Name 'C:\ProgramData\docker'

# docker daemon
Get-Service -Name docker

# docker client
docker version
docker info

# configure docker daemon
$json = '{ "graph": "c:\\docker" }'
$json | Set-Content c:\programdata\docker\config\daemon.json
New-Item -ItemType Directory -Path c:\docker

# restart service
Restart-Service -Name docker


### CN2-NUG (Nano) ###

# enter remote session
Enter-PSSession -ComputerName CN2-NUG

# install docker provider
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

# install docker
Install-Package -Name docker -ProviderName DockerMsftProvider -Force

# install the hyper-v role
Install-NanoServerPackage -Name Microsoft-NanoServer-Compute-Package

# reboot
Restart-Computer -Force

# docker install & root dir
Get-ChildItem -Name 'C:\Program Files\Docker'
Get-ChildItem -Name 'C:\ProgramData\docker'

# docker daemon
Set-Service -Name docker -StartupType Automatic
Get-Service -Name docker | Start-Service

# docker client
docker version
docker info

# configure docker daemon
$json = '{ "graph": "c:\\docker" }'
$json | Set-Content c:\programdata\docker\config\daemon.json
New-Item -ItemType Directory -Path c:\docker

# restart service
Restart-Service -Name docker