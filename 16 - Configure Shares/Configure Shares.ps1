
# generate test files
.\Generate-Files.ps1 -Path I:\Software -NumFiles 10 -TotalSize 2GB -FileType Binary
.\Generate-Files.ps1 -Path I:\Training -NumFiles 100 -TotalSize 5GB -FileType Media
.\Generate-Files.ps1 -Path U:\Company\Docs -NumFiles 200 -TotalSize 500MB -FileType Documents
.\Generate-Files.ps1 -Path U:\Stuff -NumFiles 100 -TotalSize 1GB -FileType All


# install the file server role service
Install-WindowsFeature fs-fileserver

# install the server for nfs role service (unix/linux)
Install-WindowsFeature fs-nfs-service

# view smb and nfs share related cmdlets
Get-Command -Module smbshare,nfs

# create and view smb share
New-SmbShare -Path U:\Stuff -Name UserStuff -FolderEnumerationMode AccessBased -FullAccess nuggetlab\human -ChangeAccess nuggetlab\ewok -ReadAccess nuggetlab\droid
Get-SmbShare -Name UserStuff

# view, add or remove smb access rights
Get-SmbShareAccess -Name UserStuff
Grant-SmbShareAccess -Name UserStuff -AccessRight Full -AccountName nuggetlab\wookiee -Force
Revoke-SmbShareAccess -Name UserStuff -AccountName nuggetlab\droid -Force

# block or unblock smb access
Block-SmbShareAccess -Name UserStuff -AccountName 'nuggetlab\darth.vader' -Force
Unblock-SmbShareAccess -Name UserStuff -AccountName 'nuggetlab\darth.vader' -Force

# monitor and manage share sessions
Get-SmbSession
Close-SmbSession -ClientComputerName 192.168.1.120

# configure smb server side
Get-SmbServerConfiguration
Set-SmbServerConfiguration -AuditSmb1Access $true -EnableSMB1Protocol $false -Force

# configure smb client side
Get-SmbClientConfiguration
Set-SmbClientConfiguration -SessionTimeout 120 -Force