
# install network load balancing feature and web server role on NLB nodes
Invoke-Command NLB1-NUG,NLB2-NUG,NLB3-NUG { Install-WindowsFeature NLB, RSAT-NLB, Web-Server }

# NLB cmdlets from RSAT-NLB feature
Get-Command -Module NetworkLoadBalancingClusters

# modify default IIS web page to reflect hostname
Invoke-Command NLB1-NUG,NLB2-NUG,NLB3-NUG { "Hewlo! This is <b>$env:computername</b> responding." > C:\inetpub\wwwroot\iisstart.htm }