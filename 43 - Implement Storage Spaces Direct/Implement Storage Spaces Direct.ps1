
# install required roles on nodes
Invoke-Command CL1-NUG,CL2-NUG { Install-WindowsFeature FS-FileServer,Failover-Clustering,Hyper-V -IncludeAllSubFeature }

# validate cluster requirements
Test-Cluster -Node CL1-NUG,CL2-NUG -Include "Storage Spaces Direct","Inventory","Network","System Configuration"

# create cluster without storage
New-Cluster -Name S2D-NUG -Node CL1-NUG,CL2-NUG -StaticAddress 192.168.1.150 -NoStorage

# set cluster quorum
Set-ClusterQuorum -Cluster S2D-NUG -FileShareWitness "\\dc-nug\witness"

# enable storage spaces direct
Enable-ClusterStorageSpacesDirect -CimSession S2D-NUG -CacheState Disabled

# create virtual disk, parition and format volume, add to csv
New-Volume -CimSession S2D-NUG -FriendlyName S2DvDisk -StoragePoolFriendlyName S2D* -FileSystem CSVFS_ReFS -Size 100GB