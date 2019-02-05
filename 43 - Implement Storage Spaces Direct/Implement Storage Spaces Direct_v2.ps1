
# create cluster without storage
New-Cluster -Name S2D-NUG -Node CL1-NUG,CL2-NUG -StaticAddress 192.168.1.150 -NoStorage

# set cluster quorum
Set-ClusterQuorum -Cluster S2D-NUG -FileShareWitness "\\dc-nug\witness"

# enable storage spaces direct
Enable-ClusterStorageSpacesDirect -CimSession S2D-NUG -Autoconfig $false

# reset existing disks
Invoke-Command (Get-Cluster -Name S2D-NUG | Get-ClusterNode) {
    Update-StorageProviderCache
    Get-StoragePool | Where-Object IsPrimordial -eq $false | Set-StoragePool -IsReadOnly:$false -ErrorAction SilentlyContinue
    Get-StoragePool | Where-Object IsPrimordial -eq $false | Get-VirtualDisk | Remove-VirtualDisk -Confirm:$false -ErrorAction SilentlyContinue
    Get-StoragePool | Where-Object IsPrimordial -eq $false | Remove-StoragePool -Confirm:$false -ErrorAction SilentlyContinue
    Get-PhysicalDisk | Reset-PhysicalDisk -ErrorAction SilentlyContinue
    Get-Disk | Where-Object Number -ne $null | ? IsBoot -ne $true | ? IsSystem -ne $true | ? PartitionStyle -eq RAW | Group -NoElement -Property FriendlyName
} | Sort -Property PsComputerName,Count

# create the storage pool
$disks = Get-PhysicalDisk -CimSession S2D-NUG | Where-Object CanPool -eq True
New-StoragePool -CimSession S2D-NUG -StorageSubSystemFriendlyName "*cluster*" -FriendlyName "S2D Pool" -PhysicalDisks $disks

# set the mediatype
Invoke-Command CL1-NUG,CL2-NUG { Get-PhysicalDisk | Where-Object Size -eq 50GB | Set-PhysicalDisk -MediaType SSD }
Invoke-Command CL1-NUG,CL2-NUG { Get-PhysicalDisk | Where-Object Size -eq 100GB | Set-PhysicalDisk -MediaType HDD }

# create storage tiers
New-StorageTier -CimSession S2D-NUG -StoragePoolFriendlyName S2D* -FriendlyName Capacity -MediaType HDD
New-StorageTier -CimSession S2D-NUG -StoragePoolFriendlyName S2D* -FriendlyName Performance -MediaType SSD

# create volume
New-Volume -CimSession S2D-NUG -FriendlyName S2DvDisk -StoragePoolFriendlyName S2D* -FileSystem CSVFS_ReFS -StorageTierFriendlyNames Capacity,Performance -StorageTierSizes 100GB,25GB