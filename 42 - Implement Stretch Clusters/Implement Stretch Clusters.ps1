
# test storage replica topology (run directly on CL1-NUG)
Test-SRTopology -SourceComputerName CL1-NUG -SourceVolumeName D: -SourceLogVolumeName L: -DestinationComputerName CL3-NUG -DestinationVolumeName E: -DestinationLogVolumeName M: -DurationInMinutes 1 -ResultPath C:


# enter remote session on a cluster node
Enter-PSSession CL1-NUG

# create fault domains
New-ClusterFaultDomain -Name Site1 -FaultDomainType Site -Location "East Coast"
New-ClusterFaultDomain -Name Site2 -FaultDomainType Site -Location "West Coast"

# add nodes to sites
Set-ClusterFaultDomain -Name CL1-NUG,CL2-NUG -FaultDomain Site1
Set-ClusterFaultDomain -Name CL3-NUG,CL4-NUG -FaultDomain Site2

# view fault domains
Get-ClusterFaultDomain

# set primary site
(Get-Cluster -Name CL-NUG).PreferredSite = "Site1"

# configure vm resiliency
(Get-Cluster -Name CL-NUG).ResiliencyLevel = 2
(Get-Cluster -Name CL-NUG).ResiliencyDefaultPeriod = 5
(Get-Cluster -Name CL-NUG).QuarantineThreshold = 3
(Get-Cluster -Name CL-NUG).QuarantineDuration = 3600
