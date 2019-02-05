
## iSCSI Initiators (pre-target) ##

# start iscsi initiator service on both nodes
Invoke-Command CL1-NUG,CL2-NUG { Get-Service *iscsi* | Set-Service -StartupType Automatic -PassThru | Start-Service }

# view iscsi initiator addresses
Invoke-Command CL1-NUG,CL2-NUG { Get-InitiatorPort }

# create iscsi target portal for discovery
Invoke-Command CL1-NUG,CL2-NUG { New-IscsiTargetPortal -TargetPortalAddress 192.168.3.105 }


## iSCSI Target ##

# create iscsi lun
Invoke-Command FS-NUG { New-IscsiVirtualDisk -Path D:\CL-DataDisk.vhdx -SizeBytes 100GB }
Invoke-Command FS-NUG { New-IscsiVirtualDisk -Path D:\CL-QuorumDisk.vhdx -SizeBytes 1GB }

# create iscsi target
Invoke-Command FS-NUG { New-IscsiServerTarget -TargetName CL-Target -InitiatorIds "IQN:iqn.1991-05.com.microsoft:cl1-nug.nuggetlab.com","IQN:iqn.1991-05.com.microsoft:cl2-nug.nuggetlab.com" }

# assign luns to target
Invoke-Command FS-NUG { Add-IscsiVirtualDiskTargetMapping -TargetName CL-Target -Path D:\CL-DataDisk.vhdx }
Invoke-Command FS-NUG { Add-IscsiVirtualDiskTargetMapping -TargetName CL-Target -Path D:\CL-QuorumDisk.vhdx }


## iSCSI Initiators (post-target) ##

# update discovery portal with new target information
Invoke-Command CL1-NUG,CL2-NUG { Get-IscsiTargetPortal | Update-IscsiTargetPortal }

# view iscsi target
Invoke-Command CL1-NUG,CL2-NUG { Get-IscsiTarget }

# connect initiators to target
Invoke-Command CL1-NUG,CL2-NUG { Get-IscsiTarget | Connect-IscsiTarget }

# force the connection to persist (across reboots)
Invoke-Command CL1-NUG,CL2-NUG { Get-IscsiSession | Register-IscsiSession }


## Failover Clustering ##
# install failover clustering feature on both nodes
Invoke-Command CL1-NUG,CL2-NUG { Install-WindowsFeature Failover-Clustering }

# run cluster validation
Test-Cluster -Node CL1-NUG,CL2-NUG

# create a new cluster (single domain)
New-Cluster -Name CL-NUG -Node CL1-NUG,CL2-NUG -StaticAddress 192.168.1.150

# create a new cluster (multi-domain/workgroup - no network name)
New-Cluster -Name CL-NUG -Node CL1-NUG,CL2-NUG -StaticAddress 192.168.1.150 -AdministrativeAccessPoint Dns