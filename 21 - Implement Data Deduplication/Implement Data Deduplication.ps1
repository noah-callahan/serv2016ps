
# install data deduplication
Install-WindowsFeature -Name FS-Data-Deduplication

# dedup evaluation tool
ddpeval U:
ddpeval I:
ddpeval V:

# enable data deduplication
Enable-DedupVolume -Volume V: -UsageType HyperV

# view and set volume-wide settings
Get-DedupVolume -Volume V: | Format-List *
Set-DedupVolume -Volume V: -MinimumFileAge 0

# manually run optimization job
Start-DedupJob -Type Optimization -Volume V: -Priority High -Memory 100 -Cores 100

# monitor running jobs
Get-DedupJob

# view overall status
Get-DedupStatus | Format-List *

# view and set schedule
Get-DedupSchedule
Set-DedupSchedule -Name ThroughputOptimization -Enabled $false

# disable deduplication
Start-DedupJob -Type Unoptimization -Volume V: